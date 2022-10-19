defmodule DemoWeb.GameLive do
  use Phoenix.LiveView

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    # {:ok, assign(socket, state: %Demo.State{})}
    {:ok, assign(socket, :num, 0)}
  end

  def handle_event("inc_iteration", _value, socket) do
    # {:ok, new_temp} = Thermostat.inc_temperature(socket.assigns.id)

    # TODO update the socket state
    # TODO re-render !!
    # Map.update(socket.assigns.state, :iterations, 0, fn a -> a + 1 end)
    # {:noreply, assign(socket, :iterations, 1 + socket.assigns.iterations)}
    # {:noreply, assign(socket, :state, 1 + socket.assigns.iterations)}
    {:noreply, assign(socket, :num, 1 + socket.assigns.num)}

  end
  def handle_event("dec_iteration", _value, socket) do
    # {:ok, new_temp} = Thermostat.inc_temperature(socket.assigns.id)

    # TODO update the socket state
    # TODO re-render !!
    # Map.update(socket.assigns.state, :iterations, 0, fn a -> a + 1 end)
    # {:noreply, assign(socket, :iterations, 1 + socket.assigns.iterations)}
    # {:noreply, assign(socket, :state, 1 + socket.assigns.iterations)}
    {:noreply, assign(socket, :num, -1 + socket.assigns.num)}

  end
end
