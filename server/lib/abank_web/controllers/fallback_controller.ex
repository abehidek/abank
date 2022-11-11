defmodule AbankWeb.FallbackController do
  use AbankWeb, :controller

  def call(conn, {:error, %{result: result, status: status}}) do
    conn
    |> put_status(status)
    |> put_view(AbankWeb.ErrorView)
    |> render("error.json", result: result)
  end
end
