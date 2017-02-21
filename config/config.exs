# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :double_red,
  ecto_repos: [DoubleRed.Repo]

# Configures the endpoint
config :double_red, DoubleRed.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+oEm51SvSkeDnoNzIgfIC6UUr8Pld8ih259Q0MB9wQfbLl2BHWmFfXrG276GIG9K",
  render_errors: [view: DoubleRed.ErrorView, accepts: ~w(json)],
  pubsub: [name: DoubleRed.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
