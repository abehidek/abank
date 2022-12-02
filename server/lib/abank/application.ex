defmodule Abank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Abank.Repo,
      # Start the Telemetry supervisor
      AbankWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Abank.PubSub},
      Abank.Transactions.Scheduler,
      Abank.Invoices.Scheduler,
      Abank.Loans.Scheduler,
      # Start the Endpoint (http/https)
      AbankWeb.Endpoint
      # Start a worker by calling: Abank.Worker.start_link(arg)
      # {Abank.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Abank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AbankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
