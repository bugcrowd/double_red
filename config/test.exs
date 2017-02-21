use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :double_red, DoubleRed.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Print only warnings and errors during test
config :slack, api_token: "whatever"

# Configure your database
config :double_red, DoubleRed.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "double_red_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
