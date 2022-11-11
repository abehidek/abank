defmodule AbankWeb.UserSessionView do
  use AbankWeb, :view

  def render("create.json", %{params: %{user: user}}) do
    %{
      message: "Authenticated with success",
      user: user
    }
  end

  def render("show.json", %{user: user}) do
    %{
      user: user
    }
  end

  def render("delete.json", %{result: result}) do
    %{
      message: result
    }
  end
end
