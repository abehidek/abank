defmodule AbankWeb.ArticlesController do
  use AbankWeb, :controller
  alias Abank.Articles
  alias Abank.Articles.Article
  alias AbankWeb.UserSession

  action_fallback AbankWeb.FallbackController

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(Articles.all())
  end

  def show(conn, params) do
  end

  def create(conn, %{"title" => title, "content" => content, "draft" => draft}) do
    with {:ok, user} <- UserSession.get_session(conn),
         {:ok, %Article{} = article} <-
           %{title: title, content: content, draft: draft, author: user.id}
           |> Articles.create() do
      conn
      |> put_status(:ok)
      |> json(%{article: article})
    end
  end

  def update(conn, params) do
  end

  def delete(conn, params) do
  end
end
