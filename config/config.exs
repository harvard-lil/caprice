# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :caprice,
  ecto_repos: [Caprice.Repo]

# Configures the endpoint
config :caprice, CapriceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Kn4GZ3jLv7heYwMemqkt5GQY0fubtuZD3Pc+s0BnM/FGz8v/0mx7FbLFoa4jOAd5",
  render_errors: [view: CapriceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Caprice.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
