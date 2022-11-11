defmodule AbankWeb.UserSessionController do
  alias Abank.Auth
  use AbankWeb, :controller

  action_fallback AbankWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    IO.inspect(email)
    IO.inspect(password)

    with {:ok, user} <- Auth.get_user_by_email_and_password(email, password) do
      conn
      |> put_status(:ok)
      |> render("create.json", user: user)
    end
  end
end
