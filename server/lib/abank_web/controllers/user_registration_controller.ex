defmodule AbankWeb.UserRegistrationController do
  alias Abank.Auth.User
  alias Abank.Auth
  use AbankWeb, :controller

  action_fallback AbankWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Auth.register_user(params) do
      conn |> put_status(:created) |> render("create.json", user: user)
    end
  end
end
