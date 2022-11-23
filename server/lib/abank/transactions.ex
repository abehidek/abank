defmodule Abank.Transactions do
  alias Abank.Transactions.Transaction
  alias Abank.Accounts
  # alias Abank.Accounts.Account

  def create(params) do
    params
    |> Transaction.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Transaction{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}

  def transfer(user, _to_account) do
    with {:ok, from_account} <- Accounts.get_account_by_user(user) do
      IO.puts(from_account.balance_in_cents)
      {:ok, from_account}
    else
      {:error, %{result: result, status: :forbidden}} -> {:error, %{result: result, status: :forbidden}}
    end
  end
end
