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

  def transfer(%{"type" => type} = params, user) do
    with {:ok, from_account} <- Accounts.get_account_by_user(user) do
      params = params |> Map.put("from_account_number", from_account.number)

      result =
        case type do
          "pix" -> pix(params)
          "ted" -> ted(params)
          "debit" -> debit(params)
          "credit" -> credit(params)
          _ -> {:error, %{result: "This type of transaction is not handled", status: 400}}
        end

      with {:ok, transaction} <- result, do: {:ok, transaction}
    end
  end

  def transfer(_, _) do
    {:error, %{result: "You need to pass the transaction type", status: 400}}
  end

  defp pix(params) do
    params
    |> Map.put("status", "open")
    |> Map.delete("card_number")
    |> create()
  end

  defp ted(params) do
    params
    |> Map.put("status", "open")
    |> Map.delete("card_number")
    |> create()
  end

  defp debit(params) do
    params
    |> Map.put("status", "open")
    |> create()
  end

  defp credit(params) do
    params
    |> Map.put("status", "open")
    |> create()
  end
end
