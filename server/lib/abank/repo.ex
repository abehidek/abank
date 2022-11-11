defmodule Abank.Repo do
  use Ecto.Repo,
    otp_app: :abank,
    adapter: Ecto.Adapters.Postgres
end
