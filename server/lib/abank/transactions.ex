defmodule Abank.Transactions do
  alias Abank.Transactions.Transaction

  def create(params) do
    params
    |> Transaction.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Transaction{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}

  defp transfer(from_account, to_account) do
    IO.puts(from_account.balance_in_cents)
  end
end
