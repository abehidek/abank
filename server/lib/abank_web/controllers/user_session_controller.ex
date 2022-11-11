defmodule AbankWeb.UserSessionController do
  alias Abank.Auth
  use AbankWeb, :controller

  action_fallback AbankWeb.FallbackController

  @max_age 60 * 60 * 24 * 60
  @session_cookie [sign: true, max_age: @max_age, same_site: "Lax"]

  def create(conn, %{"email" => email, "password" => password}) do
    IO.inspect(email)
    IO.inspect(password)

    with {:ok, user} <- Auth.get_user_by_email_and_password(email, password) do
      token = Auth.create_user_session_token(user)

      conn
      |> put_status(:ok)
      |> put_resp_cookie("auth_token", token, @session_cookie)
      |> render("create.json", params: %{user: user})
    end
  end

  def show(conn, _params) do
    case fetch_cookies(conn, signed: ~w(auth_token)) do
      %{cookies: %{"auth_token" => token}} -> login_response(conn, {:ok, token})
      _ -> login_response(conn, {:error, "Not logged in"})
    end
  end

  defp login_response(conn, {:ok, token}) do
    with {:ok, user} <- Auth.get_user_by_session_token(token) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  defp login_response(conn, {:error, message}) do
    conn
    |> put_status(:forbidden)
    |> put_view(AbankWeb.ErrorView)
    |> render("error.json", result: message)
  end

  def delete(conn, _params) do
    IO.inspect("> Deleting user token...")

    case fetch_cookies(conn, signed: ~w(auth_token)) do
      %{cookies: %{"auth_token" => token}} -> logout_response(conn, {:ok, token})
      _ -> logout_response(conn, {:error, "You already log out"})
    end
  end

  defp logout_response(conn, {:ok, token}) do
    with {:ok, result} <- Auth.delete_user_session_token(token) do
      IO.inspect(result)

      conn
      |> put_status(:ok)
      |> delete_resp_cookie("auth_token")
      |> render("delete.json", result: "Logout succesfully")
    end
  end

  defp logout_response(conn, {:error, message}) do
    conn
    |> put_status(:forbidden)
    |> put_view(AbankWeb.ErrorView)
    |> render("error.json", result: message)
  end
end
