defmodule AuthPoc.Repo do
  use Ecto.Repo,
    otp_app: :auth_poc,
    adapter: Ecto.Adapters.Postgres
end
