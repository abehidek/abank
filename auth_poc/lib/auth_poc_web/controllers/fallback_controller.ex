defmodule AuthPocWeb.FallbackController do
  use AuthPocWeb, :controller

  def call(conn, {:error, result}) do
    IO.inspect(result)

    conn
    # |> put_status(:error)
    # |> put_view(AuthPocWeb.ErrorView)
    # |> render("error.json", result: result)
  end
end
