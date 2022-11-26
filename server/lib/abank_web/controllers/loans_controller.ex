defmodule AbankWeb.LoansController do
  use AbankWeb, :controller

  alias Abank.Loans
  alias AbankWeb.UserSession

  action_fallback AbankWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, loan} <- Loans.new(params, user) do
      conn
      |> put_status(:ok)
      |> json(%{loan: loan})
    end
  end
end
