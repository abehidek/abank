defmodule AbankWeb.UserSessionView do
  use AbankWeb, :view
  alias AbankWeb.UserView

  def render("create.json", %{user: user}) do
    %{
      message: "Authenticated with success.",
      user: UserView.render("user.json", user: user)
    }
  end

  def render("show.json", %{user: user}) do
    %{
      user: UserView.render("user.json", user: user)
    }
  end

  def render("delete.json", %{result: result}) do
    %{
      message: result
    }
  end
end
