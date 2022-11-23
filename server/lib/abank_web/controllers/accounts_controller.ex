defmodule AbankWeb.AccountsController do
  use AbankWeb, :controller
  alias Abank.Accounts
  alias AbankWeb.UserSession

  action_fallback AbankWeb.FallbackController

  def show(conn, _params) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, account} <- Accounts.get_account_by_user(user) do
      conn
      |> put_status(:ok)
      |> json(%{account: account})
    end
  end

  def create(conn, params) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, account} <- Accounts.create(Map.put(params, "user_id", user.id)) do
      conn
      |> put_status(:ok)
      |> json(%{account: account})
    end
  end
end
