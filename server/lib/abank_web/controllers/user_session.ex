defmodule AbankWeb.UserSession do
  alias Abank.Auth
  use AbankWeb, :controller

  def get_session(conn) do
    case fetch_cookies(conn, signed: ~w(auth_token)) do
      %{cookies: %{"auth_token" => token}} -> Auth.get_user_by_session_token(token)
      _ -> {:error, %{result: "Not logged in", status: :forbidden}}
    end
  end
end
