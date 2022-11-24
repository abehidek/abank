defmodule Abank.Transactions do
  alias Abank.Transactions.Scheduler
  alias Abank.Transactions.Transaction
  alias Abank.Accounts
  # alias Abank.Accounts.Account

  def create(params) do
    params
    |> Transaction.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Transaction{} = transaction} = _result) do
    Scheduler.run_transaction(transaction)
  end

  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}

  def transfer(params, user, type) do
    with {:ok, from_account} <- Accounts.get_account_by_user(user) do
      params = params |> Map.put("from_account_number", from_account.number)

      result =
        case type do
          "pix" -> pix(params)
          "ted" -> ted(params)
        end

      with {:ok, transaction} <- result, do: {:ok, transaction}
    end
  end

  defp pix(params) do
    params
    |> Map.put("type", "pix")
    |> Map.put("status", "open")
    |> create()
  end

  defp ted(params) do
    params
    |> Map.put("type", "ted")
    |> Map.put("status", "open")
    |> create()
  end
end
