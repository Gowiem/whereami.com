defmodule WhereAmIBackend.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  @doc """
  /hello_world

  A simple 'GET' endpoint to monitor Health
  """
  get "/hello_world" do
   send_resp(conn, 200, "Hello World")
 end

  @doc """
  /location

  An endpoint to allowe the where_am_i Elixir command-line client to upload
  it's location information. This information is stored in Redis.
  """
  post "/location" do
    body_json =  Poison.Encoder.encode(conn.body_params, [])
    :poolboy.transaction(:redis_pool, fn(worker) -> Redix.command(worker, ["RPUSH", "locations", body_json]) end)
    send_resp(conn, 200, "Success!")
  end

  # Catch-all => 404
  match _ do
    send_resp(conn, 404, "Not Found!")
  end
end
