use Mix.Config

config :logger, level: :info

config :double_red, DoubleRed.Endpoint,
  http: [port: {:system, "PORT"}],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [host: "double-red.herokuapp.com"]

config :double_red, DoubleRed.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :slack,
  api_token: System.get_env("SLACK_API_TOKEN")
