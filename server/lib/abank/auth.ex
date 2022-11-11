defmodule Abank.Auth do
  import Ecto.Query, warn: false

  alias Abank.Auth.User

  def register_user(params) do
    params
    |> User.registration_changeset()
    |> Abank.Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result
  defp handle_insert({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
