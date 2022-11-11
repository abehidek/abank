defmodule AbankWeb.ExampleView do
  use AbankWeb, :view

  def render("index.json", _params) do
    %{
      message: "Example route!"
    }
  end
end
