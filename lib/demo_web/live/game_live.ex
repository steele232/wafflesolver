defmodule DemoWeb.GameLive do
  use Phoenix.LiveView
  alias Demo.Waffle.Board
  alias DemoWeb.Util.WaffleUtil
  alias DemoWeb.BoardForm
  alias DemoWeb.BoardSquareForm

  @keys [:iteration, :letters, :board, :board_form_state, :example_toggle, :example_toggle_class]

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       iteration: 0,
       example_toggle: :green,
       example_toggle_class: "button is-primary",
       board_form_state: %BoardForm{},

       # Dummy zeroed-out board to start with
       board: %Board{
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

  def handle_event("toggle_example", _value, socket) do
    current_color_atom = socket.assigns.example_toggle
    new_color_atom = current_color_atom |> WaffleUtil.cycle_color_atom()
    new_color_class = new_color_atom |> WaffleUtil.color_atom_to_bulma_color_class()
    # socket =
    #   socket
    #   |> assign(:example_toggle, new_color_atom)
    #   |> assign(:example_toggle_class, new_color_class)
    # {:noreply, socket}
    {:noreply, assign(
      socket,
      example_toggle: new_color_atom,
      example_toggle_class: new_color_class
      )}
  end

  def handle_event("update_feedback", %{"toggle" => board_entry_key}, socket) do
    board_entry_key |> IO.inspect()
    board_entry_key_atom = board_entry_key |> String.to_existing_atom() |> IO.inspect()
    newBoardState = Map.update!(
      socket.assigns.board_form_state,
      board_entry_key_atom,
      &cycleColorOnBoardSquareForm/1)
    {:noreply, assign(socket, :board_form_state, newBoardState)}
  end

  defp cycleColorOnBoardSquareForm(x = %BoardSquareForm{feedback_color: feedback_color_atom}) do
    newColorAtom = WaffleUtil.cycle_color_atom(feedback_color_atom)
    newColorClass = WaffleUtil.color_atom_to_bulma_color_class(newColorAtom)
    Map.update!(x, :feedback_color, fn _oldColorAtom -> newColorAtom end)
    |> Map.update!(:feedback_color_class, fn _oldColorClass -> newColorClass end)
  end
end
