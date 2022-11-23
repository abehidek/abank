defmodule AbankWeb.AccountsController do
  use AbankWeb, :controller
  alias Abank.{Accounts, Transactions}
  alias Abank.Accounts.Account
  alias AbankWeb.UserSession

  action_fallback AbankWeb.FallbackController

  def show(conn, _params) do
    with {:ok, user} <- UserSession.get_session(conn) do
      case Transactions.transfer(user, "no") do
        {:ok, from_account} ->
          conn
          |> put_status(:ok)
          |> json(%{account: from_account})

        {:error, result} -> conn |> put_status(403) |> json(result)
      end
    end
  end

  def create(conn, params) do
    with {:ok, user} <- UserSession.get_session(conn) do
      case Accounts.create(Map.put(params, "user_id", user.id)) do
        {:ok, account} ->
          conn
          |> put_status(:ok)
          |> json(%{account: account})
        {:error, result} ->
          conn
          |> put_status(:error)
          |> json(result)
      end
    end
  end
end
