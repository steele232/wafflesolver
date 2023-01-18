defmodule DemoWeb.GameLive do
  use Phoenix.LiveView

  @keys [:iteration, :letters]

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :iteration, 0)}
  end

  def handle_event("inc_iteration", _value, socket) do
    {:noreply, assign(socket, :iteration, 1 + socket.assigns.iteration)}

  end
  def handle_event("dec_iteration", _value, socket) do
    {:noreply, assign(socket, :iteration, -1 + socket.assigns.iteration)}
  end
  def handle_event("update_feedback", %{"toggle" => board_entry_key}, socket) do
    IO.inspect board_entry_key
    {:noreply, assign(socket, :iteration, 1 + socket.assigns.iteration)}
  end
end
