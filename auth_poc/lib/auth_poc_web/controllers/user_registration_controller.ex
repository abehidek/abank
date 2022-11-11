defmodule AuthPocWeb.UserRegistrationController do
  use AuthPocWeb, :controller

  alias AuthPoc.Accounts
  alias AuthPoc.Accounts.User
  alias AuthPocWeb.UserAuth

  action_fallback AuthPocWeb.FallbackController

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params) do
      {:ok, _} =
        Accounts.deliver_user_confirmation_instructions(
          user,
          &Routes.user_confirmation_url(conn, :edit, &1)
        )

      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end

    # case Accounts.register_user(user_params) do
    #   {:ok, user} ->
    #     {:ok, _} =
    #       Accounts.deliver_user_confirmation_instructions(
    #         user,
    #         &Routes.user_confirmation_url(conn, :edit, &1)
    #       )

    #     conn
    #     |> put_status(:created)
    #     |> render("create.json", user: user)

    #   # |> put_flash(:info, "User created successfully.")
    #   # |> UserAuth.log_in_user(user)

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end
end
