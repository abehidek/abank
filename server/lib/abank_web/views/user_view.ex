defmodule AbankWeb.UserView do
  use AbankWeb, :view

  def render("user.json", %{user: user}) do
    %{
      email: user.email,
      hashed_password: user.hashed_password,
      confirmed_at: user.confirmed_at,
      password: user.password
    }
  end
end
