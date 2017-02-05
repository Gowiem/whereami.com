use Mix.Config

config :where_am_i_com, redis_port: 6379
import_config "#{Mix.env}.exs"
