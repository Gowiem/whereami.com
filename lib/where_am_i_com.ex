defmodule WhereAmIBackend do
  @moduledoc """
  The Plug Backend for the Gowiem/where_am_i repo. Stores locations from where_am_i in a Redis Database for later use.
  """
  use Application
  require Logger

  def start(_type, _args) do
    pool_options = [
       {:name, {:local, :redis_pool}},
       {:worker_module, Redix},
       {:size, 5},
       {:max_overflow, 10}
    ]

    redix_args = [
      {:host, Application.get_env(:where_am_i_com, :redis_host)},
      {:port, Application.get_env(:where_am_i_com, :redis_port)}
    ]

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, WhereAmIBackend.Router, [], port: 8080),
      :poolboy.child_spec(:redis_pool, pool_options, redix_args)
    ]

    Logger.info "Started application"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
