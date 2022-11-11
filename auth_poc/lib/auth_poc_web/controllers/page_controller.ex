defmodule AuthPocWeb.PageController do
  use AuthPocWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
