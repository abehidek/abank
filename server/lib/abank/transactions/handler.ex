defmodule Abank.Transactions.Handler do
  alias Abank.Accounts
  alias Abank.Transactions.Transaction

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

  defp normal_transaction(transaction, from_account, to_account) do
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

  defp credit_transaction(transaction, from_account, to_account) do
    # this needs to search the account invoice (needs a method for get invoices by account)
    # verify if the invoice amount is less than the account limit
    IO.inspect(transaction)
    IO.inspect(from_account)
    IO.inspect(to_account)
    {:ok, %{result: "Credit transaction successfully"}}
  end

  def run_transaction(%Transaction{} = transaction) do
    # get account by number from transaction
    with {:ok, from_account} <- Accounts.get_account_by_number(transaction.from_account_number),
         {:ok, to_account} <- Accounts.get_account_by_number(transaction.to_account_number) do
      case transaction.type do
        "credit" -> credit_transaction(transaction, from_account, to_account)
        _ -> normal_transaction(transaction, from_account, to_account)
      end
    end
  end
end
