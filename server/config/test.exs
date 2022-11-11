import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :abank, Abank.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "abank_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :abank, AbankWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IjdBIxKRUsbTlD2YmDhrEo4clyOkCwOGFY5a8FerApL5nbQ/o2iaPOQnoCHTRVHZ",
  server: false

# In test we don't send emails.
config :abank, Abank.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
