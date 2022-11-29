defmodule AbankWeb.Router do
  use AbankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AbankWeb do
    pipe_through :api

    scope "/users" do
      get "/me", UserSessionController, :show
      post "/login", UserSessionController, :create
      post "/register", UserRegistrationController, :create
      delete "/logout", UserSessionController, :delete
    end

    scope "/accounts" do
      get "/", AccountsController, :show
      post "/", AccountsController, :create
    end

    scope "/cards" do
      get "/", CardsController, :index
      post "/", CardsController, :create
    end

    scope "transactions" do
      get "/", TransactionsController, :index
      post "/", TransactionsController, :create
    end

    scope "/test" do
      post "/loans", LoansController, :create
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AbankWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
