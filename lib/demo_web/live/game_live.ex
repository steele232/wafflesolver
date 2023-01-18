defmodule DemoWeb.GameLive do
  use Phoenix.LiveView
  alias Demo.Waffle.Board

  @keys [:iteration, :letters, :board]

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       iteration: 0,
       board: %Board{ # Dummy zeroed-out board to start with
         characterStrings: [
           ["a", "a", "a", "a", "a"],
           ["a", " ", "a", " ", "a"],
           ["a", "a", "a", "a", "a"],
           ["a", " ", "a", " ", "a"],
           ["a", "a", "a", "a", "a"]
         ],
         feedbackStrings: [
           ["2", "0", "0", "0", "2"],
           ["0", " ", "0", " ", "0"],
           ["0", "0", "0", "0", "0"],
           ["0", " ", "0", " ", "0"],
           ["2", "0", "0", "0", "2"]
         ]
       }
     )}
  end

  def handle_event("inc_iteration", _value, socket) do
    {:noreply, assign(socket, :iteration, 1 + socket.assigns.iteration)}
  end

  def handle_event("dec_iteration", _value, socket) do
    {:noreply, assign(socket, :iteration, -1 + socket.assigns.iteration)}
  end

  def handle_event("update_feedback", %{"toggle" => board_entry_key}, socket) do
    board_entry_key |> IO.inspect()

    # TODO make sure we are not vulnerable to atom memory leaks; see if I can make an enum out of this or something.. IDK
    board_entry_key |> String.to_existing_atom() |> IO.inspect()
    {:noreply, assign(socket, :iteration, 1 + socket.assigns.iteration)}
  end
end
