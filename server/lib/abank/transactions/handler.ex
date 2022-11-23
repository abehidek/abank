defmodule Abank.Transactions.Handler do
  alias Abank.Accounts
  alias Abank.Transactions.Transaction

  def call() do
    # get all transactions with "open" status
    {:ok, query} = Transaction.get_open_transactions()

    _open_transactions =
      query
      |> Abank.Repo.all()

    # open_transactions
    # |> Task.async_stream()
  end

  def run_transaction(%Transaction{} = transaction) do
    # get account by number from transaction
    with {:ok, from_account} <- Accounts.get_account_by_number(transaction.from_account_number),
         {:ok, to_account} <- Accounts.get_account_by_number(transaction.to_account_number) do
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
            status: "closed"
          )
        )
      end)

      {:ok, %{message: "Success"}}
    end
  end
end
