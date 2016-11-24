# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dumb_app,
  ecto_repos: [DumbApp.Repo]

# Configures the endpoint
config :dumb_app, DumbApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qLBou0wYt38czORzlXC6BQQn1y+liB5vj/EyjQgAZhyNq+qgYMwL0Fhanhmqboz5",
  render_errors: [view: DumbApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DumbApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
