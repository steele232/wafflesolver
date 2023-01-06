defmodule DemoWeb.GameMvcController do
  use DemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def solved(conn, params) do
    IO.inspect("dunbinsolved")
    IO.inspect("params below")
    IO.inspect(params)
    render(conn, "solved.html", params)
  end
end
