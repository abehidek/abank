# to be used when inside server directory

mix deps.get

mix ecto.create

mix ecto.migrate

mix run priv/repo/seeds.exs
