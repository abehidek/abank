defmodule AbankWeb.CardsController do
  use AbankWeb, :controller

  alias Abank.Cards
  alias AbankWeb.UserSession

  action_fallback AbankWeb.FallbackController

  def index(conn, _params) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, cards} <- Cards.all(user) do
      conn
      |> put_status(:ok)
      |> json(%{cards: cards})
    end
  end

  def create(conn, params) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, card} <- Cards.new(params, user) do
      conn
      |> put_status(:ok)
      |> json(%{card: card})
    end
  end
end
