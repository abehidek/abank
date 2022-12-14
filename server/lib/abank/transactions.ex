defmodule Abank.Transactions do
  alias Abank.Transactions.Scheduler
  alias Abank.Transactions.Transaction
  alias Abank.Accounts
  # alias Abank.Accounts.Account

  def all(user) do
    with {:ok, account} <- Accounts.get_account_by_user(user) do
      {:ok, query} = Transaction.get_transactions_by_account_number(account.number)

      transactions = query |> Abank.Repo.all()

      if transactions do
        {:ok, transactions}
      else
        {:error, %{result: "No transactions found", status: 403}}
      end
    end
  end

  def create(params) do
    params
    |> Transaction.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  def create_to_bank_transaction(params) do
    params
    |> Transaction.to_bank_transaction_changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  def create_from_bank_transaction(params) do
    params
    |> Transaction.from_bank_transaction_changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Transaction{} = transaction} = _result) do
    Scheduler.run_transaction(transaction)
  end

  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}

  def transfer(%{"type" => "deposit"} = params, user) do
    with {:ok, to_account} <- Accounts.get_account_by_user(user) do
      result =
        params
        |> Map.put("to_account_number", to_account.number)
        |> Map.delete("from_account_number")
        |> Map.put("status", "open")
        |> Map.delete("card_number")
        |> IO.inspect(label: "PARAMS")
        |> create_from_bank_transaction()

      with {:ok, transaction} <- result, do: {:ok, transaction}
    end
  end

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
