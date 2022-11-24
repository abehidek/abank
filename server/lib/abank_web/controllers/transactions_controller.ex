defmodule AbankWeb.TransactionsController do
  use AbankWeb, :controller

  alias Abank.Transactions
  alias AbankWeb.UserSession

  action_fallback AbankWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, transaction} <- Transactions.transfer(params, user) do
      conn
      |> put_status(:ok)
      |> json(%{transaction: transaction})
    end
  end
end
