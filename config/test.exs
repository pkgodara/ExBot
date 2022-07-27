import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_bot, ExBotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WBp/T9bXv90NbH2iF3njFxGvcHWRmKTrhYWFdobtiqUL/2VmKmZlpXZBp+mMUoY9",
  server: false

# In test we don't send emails.
config :ex_bot, ExBot.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :ex_bot, fb_api_impl: FbMockAPI
config :ex_bot, coingecko_api_impl: CoinGeckoMockAPI
config :ex_bot, http_adapter: HttpMock
