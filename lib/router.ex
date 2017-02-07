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
  /last_location

  An endpoint to fetch the last location pushed onto the 'locations' REDIS list.
  Returns the full JSON payload of that last entry.
  """
  get "/last_location" do
    {:ok, location_json } = :poolboy.transaction(:redis_pool, fn(worker) -> Redix.command(worker, ~w(LINDEX locations -1)) end)
    conn = conn |> Plug.Conn.put_resp_header("content-type", "application/json")
                |> Plug.Conn.put_resp_header("Access-Control-Allow-Origin", "https://mattgowie.com")
    send_resp(conn, 200, location_json)
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
