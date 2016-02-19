# Toy plug - drop into any pipeline to inspect what's been done so
# far with the connection
defmodule Rumbl.ConnectionLogger do
  def init(opts) do
    IO.inspect ["on init, given opts", opts]
    opts
  end

  def call(conn, opts) do
    IO.inspect ["on call, opts", opts, "conn is", conn]
    conn
  end

end
