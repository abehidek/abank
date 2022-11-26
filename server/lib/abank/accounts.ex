defmodule Abank.Accounts do
  alias Abank.Accounts.{Account}

  def get_account_by_number(number) when is_binary(number) do
    {:ok, query} = Account.get_account_by_number(number)

    account = query |> Abank.Repo.one()

    if account do
      {:ok, account}
    else
      {:error, %{result: "Account not found", status: 403}}
    end
  end

  def get_account_by_number(number) when is_nil(number) do
    nil
  end

  def get_account_by_user(user) do
    {:ok, query} = Account.get_account_by_user(user)

    account =
      query
      |> Abank.Repo.one()

    if account do
      {:ok, account}
    else
      {:error, %{result: "Account not found", status: 403}}
    end
  end

  def create(params) do
    params
    |> Map.delete("max_limit")
    |> Map.delete("score")
    |> Map.delete("balance_in_cents")
    |> Map.put("number", Integer.to_string(Enum.random(10_000_000..99_999_999)))
    |> Account.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  def sufficient_balance?(decreased_value_in_cents, %Account{} = account) do
    account.balance_in_cents >= decreased_value_in_cents
  end

  defp handle_create({:ok, %Account{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
