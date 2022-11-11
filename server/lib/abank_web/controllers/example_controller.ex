defmodule AbankWeb.ExampleController do
  use AbankWeb, :controller

  action_fallback AbankWeb.FallbackController

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("index.json")
  end
end
