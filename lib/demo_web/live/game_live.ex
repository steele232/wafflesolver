defmodule DemoWeb.GameLive do
  use Phoenix.LiveView
  alias Demo.Waffle.Board
  alias DemoWeb.Util.WaffleUtil
  alias DemoWeb.BoardForm
  alias DemoWeb.BoardSquareForm

  @keys [:board_form_state, :board, :iteration]

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
      assign(socket,
        iteration: 0,
        board: nil,
        board_form_state: %BoardForm{}
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
    board_entry_key_atom = board_entry_key |> String.to_existing_atom() |> IO.inspect()
    newBoardState = Map.update!(
      socket.assigns.board_form_state,
      board_entry_key_atom,
      &cycleColorOnBoardSquareForm/1)
    {:noreply, assign(socket, :board_form_state, newBoardState)}
  end
  # def handle_event("update_form", paramMap, socket) do
    # paramMap |> IO.inspect
    # {:noreply, socket}
  # end

  defp cycleColorOnBoardSquareForm(x = %BoardSquareForm{feedback_color: feedback_color_atom}) do
    newColorAtom = WaffleUtil.cycle_color_atom(feedback_color_atom)
    newColorClass = WaffleUtil.color_atom_to_bulma_color_class(newColorAtom)
    Map.update!(x, :feedback_color, fn _oldColorAtom -> newColorAtom end)
    |> Map.update!(:feedback_color_class, fn _oldColorClass -> newColorClass end)
  end
end
