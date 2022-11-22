defmodule Abank.Accounts do
  alias Abank.Accounts.{Account}

  def create(params) do
    params
    |> Account.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Account{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
