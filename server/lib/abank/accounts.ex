defmodule Abank.Accounts do
  alias Abank.Accounts.{Account}

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
    |> Account.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Account{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
