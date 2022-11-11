defmodule AbankWeb.UserRegistrationView do
  use AbankWeb, :view

  def render("create.json", %{user: user}) do
    %{
      message: "User created successfully",
      user: user
    }
  end
end
