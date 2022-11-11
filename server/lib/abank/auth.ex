defmodule Abank.Auth do
  import Ecto.Query, warn: false

  alias Abank.Auth.{User, UserSession}

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

  def get_user_by_session_token(token) do
    # IO.inspect(token)
    {:ok, query} = UserSession.verify_session_token_query(token)
    user = Abank.Repo.one(query)

    if user do
      {:ok, user}
    else
      {:error, %{result: "Session not found", status: :forbidden}}
    end
  end

  def create_user_session_token(user) do
    {token, user_session} = UserSession.build_session_token(user)
    Abank.Repo.insert!(user_session)
    token
  end

  def delete_user_session_token(token) do
    token = UserSession.get_token(token)
    result = Abank.Repo.delete_all(token)
    {:ok, result}
  end
end
