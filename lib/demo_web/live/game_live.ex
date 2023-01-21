defmodule DemoWeb.GameLive do
  use Phoenix.LiveView
  alias Mix.Tasks.Do
  alias Demo.Waffle.Board
  alias DemoWeb.Util.WaffleUtil
  alias DemoWeb.BoardForm
  alias DemoWeb.BoardSquareForm

  @keys [:board_form_state, :board, :current_fsm_state, :previous_fsm_state, :latest_solution]

  @my_fsm_state [:explanation, :begin_letters_form, :begin_feedback_form, :display_solution]

  def render(assigns) do
    DemoWeb.GameView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       board: nil,
       current_fsm_state: :explanation,
       previous_fsm_state: :explanation,
       board_form_state: %BoardForm{},
       latest_solution: nil
     )}
  end

  def handle_event("start_solving", _params, socket) do
    {:noreply, assign(socket, :current_fsm_state, :begin_letters_form)}
  end

  def handle_event("letters_back", _params, socket) do
    IO.inspect(socket.assigns, label: "letters_back socket assigns")
    {:noreply, assign(socket, :current_fsm_state, socket.assigns.previous_fsm_state)}
  end

  def handle_event("save_board_letters_form", paramMap, socket) do
    paramMap |> IO.inspect(label: "save_board_letters_form")

    # lowercase all user input for processing
    paramMap = paramMap |> Enum.map(fn {k, input} -> {k, input |> String.downcase()} end) |> Enum.into(%{})

    %{
      "v1h1" => v1h1,
      "v1h2" => v1h2,
      "v1h3" => v1h3,
      "v1h4" => v1h4,
      "v1h5" => v1h5,
      "v2h1" => v2h1,
      "v2h3" => v2h3,
      "v2h5" => v2h5,
      "v3h1" => v3h1,
      "v3h2" => v3h2,
      "v3h3" => v3h3,
      "v3h4" => v3h4,
      "v3h5" => v3h5,
      "v4h1" => v4h1,
      "v4h3" => v4h3,
      "v4h5" => v4h5,
      "v5h1" => v5h1,
      "v5h2" => v5h2,
      "v5h3" => v5h3,
      "v5h4" => v5h4,
      "v5h5" => v5h5
    } = paramMap
    newBoard = %Board{
      characterStrings: [
        [v1h1,v1h2,v1h3,v1h4,v1h5],
        [v2h1," ",v2h3," ",v2h5],
        [v3h1,v3h2,v3h3,v3h4,v3h5],
        [v4h1," ",v4h3," ",v4h5],
        [v5h1,v5h2,v5h3,v5h4,v5h5]
      ]
    }
    newBoardFormState = BoardForm.fromLettersMap(paramMap)

    socket =
      socket
      |> assign(:board, newBoard)
      |> assign(:board_form_state, newBoardFormState)
      |> assign(:current_fsm_state, :begin_feedback_form)
      |> assign(:previous_fsm_state, :begin_letters_form)

    {:noreply, socket}
  end

  def handle_event("feedback_back", _params, socket) do
    {:noreply, assign(socket, :current_fsm_state, :begin_letters_form)}
  end

  def handle_event("update_feedback", %{"toggle" => board_entry_key}, socket) do
    board_entry_key |> IO.inspect()
    board_entry_key_atom = board_entry_key |> String.to_existing_atom() |> IO.inspect()

    newBoardState =
      Map.update!(
        socket.assigns.board_form_state,
        board_entry_key_atom,
        &cycleColorOnBoardSquareForm/1
      )

    {:noreply, assign(socket, :board_form_state, newBoardState)}
  end

  defp cycleColorOnBoardSquareForm(x = %BoardSquareForm{feedback_color: feedback_color_atom}) do
    newColorAtom = WaffleUtil.cycle_color_atom(feedback_color_atom)
    newColorClass = WaffleUtil.color_atom_to_bulma_color_class(newColorAtom)

    Map.update!(x, :feedback_color, fn _oldColorAtom -> newColorAtom end)
    |> Map.update!(:feedback_color_class, fn _oldColorClass -> newColorClass end)
  end

  defp updateCharacterOnBoardSquareForm(x = %BoardSquareForm{}, newCharacter) do
    Map.update!(x, :character, fn _oldChar -> newCharacter end)
  end

  def handle_event("save_board_feedbacks_form", paramMap, socket) do
    paramMap |> IO.inspect(label: "save_board_feedbacks_form")

    # TODO ... solve it now!!!

    # TODO just read in ALL the letters and ... IDK yell if one is missing(?) Ecto changesets would be nice.. but maybe I can refactor to that in a bit..

    # TODO handle letters submission, possibly any capitalization things, etc

    # TODO save the board variable -- with characters only; we can always go back and make a new instance with the feedbacks included..
    #   TODO save the board as
    # TODO prop up the board_form_state variable for feedback button toggling
    #   TODO save the board form state as is
    # TODO do the above^ by iterating through the params map..
    newBoard = nil
    newBoardFormState = nil

    # %{"v1h1" => newChar} = paramMap

    # newBoardState =
    #   Map.update!(
    #     socket.assigns.board_form_state,
    #     :v1h1,
    #     fn oldBoardFormState -> updateCharacterOnBoardSquareForm(oldBoardFormState, newChar) end
    #   )

    latestSolution = nil

    socket =
      socket
      |> assign(:board, newBoard)
      |> assign(:board_form_state, newBoardFormState)
      |> assign(:current_fsm_state, :display_solution)
      |> assign(:previous_fsm_state, :begin_feedback_form)
      |> assign(:latest_solution, latestSolution)

    {:noreply, socket}
  end

  def handle_event("add_another_feedback_cycle", _params, socket) do
    {:noreply,
     assign(socket,
       current_fsm_state: :begin_letters_form,
       previous_fsm_state: :display_solution,
       board_form_state: %BoardForm{}
     )}
  end
end
