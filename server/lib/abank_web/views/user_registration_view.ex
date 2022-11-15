defmodule AbankWeb.UserRegistrationView do
  use AbankWeb, :view

  alias AbankWeb.UserView

  def render("create.json", %{user: user}) do
    %{
      message: "User created successfully",
      user: UserView.render("user.json", %{user: user})
    }
  end
end
