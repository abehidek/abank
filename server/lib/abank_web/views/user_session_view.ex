defmodule AbankWeb.UserSessionView do
  use AbankWeb, :view

  def render("create.json", %{user: user}) do
    %{
      message: "Authenticated with success",
      user: user
    }
  end
end
