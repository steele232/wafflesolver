defmodule DemoWeb.GameLive do
  use Phoenix.LiveView

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, state: %Demo.State{})}
  end
end
