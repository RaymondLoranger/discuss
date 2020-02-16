# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Mix messages in colors...
config :elixir, ansi_enabled: true

# General application configuration
config :discuss, ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  # Overridden with the prod secret config file.
  secret_key_base:
    "ZnYfmIVKCU5slVGAWOUknc+Z5fYY/8uXWzD6fFIzKylwDixE6qb2UaZoeEoupff2",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]

# Overridden with secret config files.
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "***",
  client_secret: "***"

# Overridden with secret config files.
config :discuss, Discuss.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "***",
  password: "***",
  database: "***",
  hostname: "***",
  pool_size: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
