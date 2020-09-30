use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :murky, MurkyWeb.Endpoint,
  http: [port: 4002],
  server: false

config :murky,
  storage_path: System.get_env("STORAGE_PATH") || "test_data/"

# Print only warnings and errors during test
config :logger, level: :warn
