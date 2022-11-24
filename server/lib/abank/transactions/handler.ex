defmodule Abank.Transactions.Handler do
  alias Abank.Accounts
  alias Abank.Transactions.Transaction

  def call() do
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

  def run_transaction(%Transaction{} = transaction) do
    # get account by number from transaction
    with {:ok, from_account} <- Accounts.get_account_by_number(transaction.from_account_number),
         {:ok, to_account} <- Accounts.get_account_by_number(transaction.to_account_number) do
      if Accounts.sufficient_balance?(transaction.amount_in_cents, from_account) do
        Abank.Repo.transaction(fn ->
          Abank.Repo.update!(
            Ecto.Changeset.change(from_account,
              balance_in_cents: from_account.balance_in_cents - transaction.amount_in_cents
            )
          )

          Abank.Repo.update!(
            Ecto.Changeset.change(to_account,
              balance_in_cents: to_account.balance_in_cents + transaction.amount_in_cents
            )
          )

          Abank.Repo.update!(
            Ecto.Changeset.change(transaction,
              status: "approved"
            )
          )
        end)

        {:ok, %{result: "Success"}}
      else
        Abank.Repo.transaction(fn ->
          Abank.Repo.update!(
            Ecto.Changeset.change(transaction,
              status: "rejected"
            )
          )
        end)

        {:error, %{result: "Rejected because insufficient balance"}}
      end
    end
  end
end
