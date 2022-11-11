defmodule AuthPocWeb.UserRegistrationView do
  use AuthPocWeb, :view

  def render("create.json", %{user: user}) do
    %{
      message: "User created",
      user: user
    }
  end
end
