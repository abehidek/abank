defmodule Abank.Transactions.Handler do
  alias Abank.Accounts
  alias Abank.Transactions.Transaction
  alias Abank.Invoices.Invoice
  alias Abank.Invoices.Handler
  alias Abank.Cards.Card

  alias Abank.Loans
  alias Abank.Loans.Loan

  def run_all_transactions() do
    # get all transactions with "open" status
    {:ok, query} = Transaction.get_open_transactions()

    open_transactions =
      query
      |> Abank.Repo.all()
      |> IO.inspect()

    if open_transactions do
      open_transactions
      |> Enum.sort_by(&by_inserted_at/1, :asc)
      |> Enum.each(fn transaction -> run_transaction(transaction) end)
    end
  end

  defp by_inserted_at(%Transaction{} = transaction) do
    transaction.inserted_at
  end

  defp normal_transaction(transaction, from_account, to_account)
       when is_map(to_account) and is_map(from_account) do
    if Accounts.sufficient_balance?(transaction.amount_in_cents, from_account) do
      with {:ok, result} <-
             Abank.Repo.transaction(fn ->
               Ecto.Changeset.change(from_account,
                 balance_in_cents: from_account.balance_in_cents - transaction.amount_in_cents
               )
               |> Abank.Repo.update!()

               Ecto.Changeset.change(to_account,
                 balance_in_cents: to_account.balance_in_cents + transaction.amount_in_cents
               )
               |> Abank.Repo.update!()

               Ecto.Changeset.change(transaction,
                 status: "approved"
               )
               |> Abank.Repo.update!()
             end) do
        {:ok, %{result: result}}
      else
        {:error, result} ->
          IO.inspect(result)
          {:error, %{result: "Something bad happened", status: 500}}
      end
    else
      Abank.Repo.transaction(fn ->
        Ecto.Changeset.change(transaction,
          status: "rejected"
        )
        |> Abank.Repo.update!()
      end)

      {:error, %{result: "Rejected because insufficient balance", status: 400}}
    end
  end

  defp normal_transaction(%Transaction{type: "deposit"} = transaction, nil, to_account) do
    with {:ok, result} <-
           Abank.Repo.transaction(fn ->
             to_account
             |> Ecto.Changeset.change(
               balance_in_cents: to_account.balance_in_cents + transaction.amount_in_cents
             )
             |> Abank.Repo.update!()

             transaction
             |> Ecto.Changeset.change(status: "approved")
             |> Abank.Repo.update!()
           end) do
      {:ok, %{result: result}}
    else
      {:error, result} ->
        IO.inspect(result)
        {:error, %{result: "Something bad happened", status: 500}}

      _ ->
        {:error, %{result: "Something really bad happened", status: 500}}
    end
  end

  defp normal_transaction(%Transaction{type: "loan_payment"} = transaction, from_account, nil) do
    if Accounts.sufficient_balance?(transaction.amount_in_cents, from_account) do
      with {:ok, %Loan{} = approved_or_late_loan} <-
             from_account.number |> Loans.get_approved_or_late_loan(),
           {:ok, result} <-
             Abank.Repo.transaction(fn ->
               from_account
               |> Ecto.Changeset.change(
                 balance_in_cents: from_account.balance_in_cents - transaction.amount_in_cents
               )
               |> Abank.Repo.update!()

               approved_or_late_loan
               |> Ecto.Changeset.change(status: "payed")
               |> Abank.Repo.update!()

               transaction
               |> Ecto.Changeset.change(status: "approved")
               |> Abank.Repo.update!()
             end) do
        {:ok, %{result: result}}
      else
        {:error, result} ->
          IO.inspect(result)
          {:error, %{result: "Something bad happened", status: 500}}
      end
    else
      Abank.Repo.transaction(fn ->
        Ecto.Changeset.change(transaction,
          status: "rejected"
        )
        |> Abank.Repo.update!()
      end)

      {:error, %{result: "Rejected because insufficient balance", status: 400}}
    end
  end

  defp credit_transaction(%Transaction{} = transaction, _from_account, to_account) do
    # this needs to search the account invoice (needs a method for get invoices by account)
    # verify if the invoice amount is less than the account limit

    {:ok, card_by_number_query} = Card.get_card_by_number_query(transaction.card_number)

    credit_card = card_by_number_query |> Abank.Repo.one()

    {:ok, open_invoice_by_credit_card_query} =
      Invoice.get_open_invoice_by_credit_card_query(credit_card)

    open_invoice =
      open_invoice_by_credit_card_query
      |> Abank.Repo.one()

    if open_invoice do
      if transaction.amount_in_cents > credit_card.limit_in_cents - open_invoice.amount_in_cents do
        with {:ok, _result} <-
               Abank.Repo.transaction(fn ->
                 transaction
                 |> Ecto.Changeset.change(status: "rejected")
                 |> Abank.Repo.update!()
               end) do
          {:error, %{result: "Your transaction surpass the credit card limit.", status: 400}}
        else
          {:error, result} ->
            IO.inspect(result)
            {:error, %{result: "Something bad happened", status: 500}}
        end
      else
        with {:ok, result} <-
               Abank.Repo.transaction(fn ->
                 open_invoice
                 |> Ecto.Changeset.change(
                   amount_in_cents: open_invoice.amount_in_cents + transaction.amount_in_cents
                 )
                 |> Abank.Repo.update!()

                 to_account
                 |> Ecto.Changeset.change(
                   balance_in_cents: to_account.balance_in_cents + transaction.amount_in_cents
                 )
                 |> Abank.Repo.update!()

                 transaction
                 |> Ecto.Changeset.change(status: "approved")
                 |> Abank.Repo.update!()
               end) do
          {:ok, %{result: result}}
        else
          {:error, result} ->
            IO.inspect(result)
            {:error, %{result: "Something bad happened", status: 500}}
        end
      end
    else
      Handler.verify_credit_card_invoices_status(credit_card)
    end
  end

  def run_transaction(%Transaction{} = transaction) do
    # get account by number from transaction

    cond do
      transaction.from_account_number ->
        with {:ok, from_account} <-
               Accounts.get_account_by_number(transaction.from_account_number) do
          case Accounts.get_account_by_number(transaction.to_account_number) do
            {:ok, to_account} ->
              case transaction.type do
                "credit" -> credit_transaction(transaction, from_account, to_account)
                _ -> normal_transaction(transaction, from_account, to_account)
              end

            {:error, %{result: "Account not found", status: 403}} ->
              nil

            nil ->
              case transaction.type do
                "credit" ->
                  {:error, %{result: "Credit transfer to bank not allowed", status: 403}}

                _ ->
                  normal_transaction(transaction, from_account, nil)
              end
          end
        end

      transaction.to_account_number ->
        with {:ok, to_account} <- Accounts.get_account_by_number(transaction.to_account_number) do
          case transaction.type do
            "deposit" -> normal_transaction(transaction, nil, to_account)
            _ -> {:error, %{result: "Transaction not supported", status: 400}}
          end
        end
    end
  end
end
