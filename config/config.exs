use Mix.Config

# Disable colors during tests.
config :logger, :console, colors: [enabled: false]

# Use higher stacktrace depth.
config :phoenix, :stacktrace_depth, 20

# Make comeonin faster by reducing its encryption power
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

config :keeper, :dumb_app_path, "test/support/dumb_app"
