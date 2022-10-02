import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :home_automation, HomeAutomation.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "home_automation_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :home_automation, HomeAutomationWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gO7g3xh4ofl5P0g/IK4Yow4JbvR+/HDQLfStPU+C6nmVAwnVJp9hb2n2NRdjfooB",
  server: false

#config Oban
config :home_automation, Oban, testing: :inline

# In test we don't send emails.
config :home_automation, HomeAutomation.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
