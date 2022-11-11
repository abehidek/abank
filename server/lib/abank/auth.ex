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

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Abank.Repo.get_by(User, email: email)

    if User.valid_password?(user, password) do
      {:ok, user}
    else
      {:error, %{result: "Invalid email or password", status: :forbidden}}
    end
  end
end
