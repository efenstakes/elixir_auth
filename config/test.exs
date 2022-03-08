import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :authr_uno, AuthrUno.Repo,
  username: "root",
  password: "",
  hostname: "localhost",
  database: "authr_uno_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :authr_uno, AuthrUnoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "/jRolL/h/5xSD0gUZ5apWzxqWAYvCm4JYvr2d9/pPFo/3UM3SAF3vkO63l9txlr4",
  server: false

# In test we don't send emails.
config :authr_uno, AuthrUno.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
