defmodule DemoWeb.GameLive do
  use Phoenix.LiveView
  alias Demo.Waffle
  alias Demo.Waffle.Board
  alias DemoWeb.Util.WaffleUtil
  alias DemoWeb.BoardForm
  alias DemoWeb.BoardSquareForm

  @keys [
    :board_form_state,
    :board,
    :current_fsm_state,
    :previous_fsm_state,
    :latest_solution,
    :board_history
  ]

  @my_fsm_states [:explanation, :begin_letters_form, :begin_feedback_form, :display_solution]

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
       latest_solution: nil,
       board_history: []
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
    paramMap =
      paramMap |> Enum.map(fn {k, input} -> {k, input |> String.downcase()} end) |> Enum.into(%{})

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
        [v1h1, v1h2, v1h3, v1h4, v1h5],
        [v2h1, " ", v2h3, " ", v2h5],
        [v3h1, v3h2, v3h3, v3h4, v3h5],
        [v4h1, " ", v4h3, " ", v4h5],
        [v5h1, v5h2, v5h3, v5h4, v5h5]
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

  def handle_event("save_board_feedbacks_form", _paramMap, socket) do
    # TODO :: data transformation
    #   board-form-state -> %Board{} for the SOLVE call
    # TODO ... solve it now!!!
    # TODO then assign :latest_solution

    oldBoard = socket.assigns.board
    oldCharacters = oldBoard.characterStrings
    oldBoardFormState = socket.assigns.board_form_state

    fbMap =
      oldBoardFormState
      |> Map.to_list()
      |> Enum.filter(fn {k,_v} -> k != :__struct__ end)
      |> IO.inspect(label: "save_board_feedbacks_form post filtering")
      |> Enum.map(fn {k,
                      %DemoWeb.BoardSquareForm{
                        feedback_color: feedback_color,
                        is_intersection: is_intersection
                      } = _v} ->
        num = getSolverSquareFeedbackNumber(feedback_color, is_intersection)
        numStr = num |> Integer.to_string()
        {k, numStr}
      end)
      |> Enum.into(%{})

    newBoard = %Board{
      characterStrings: oldCharacters,
      feedbackStrings: [
        [Map.get(fbMap,:v1h1), Map.get(fbMap,:v1h2), Map.get(fbMap,:v1h3), Map.get(fbMap,:v1h4), Map.get(fbMap,:v1h5)],
        [Map.get(fbMap,:v2h1), " ", Map.get(fbMap,:v2h3), " ", Map.get(fbMap,:v2h5)],
        [Map.get(fbMap,:v3h1), Map.get(fbMap,:v3h2), Map.get(fbMap,:v3h3), Map.get(fbMap,:v3h4), Map.get(fbMap,:v3h5)],
        [Map.get(fbMap,:v4h1), " ", Map.get(fbMap,:v4h3), " ", Map.get(fbMap,:v4h5)],
        [Map.get(fbMap,:v5h1), Map.get(fbMap,:v5h2), Map.get(fbMap,:v5h3), Map.get(fbMap,:v5h4), Map.get(fbMap,:v5h5)]
      ]
    }

    oldBoardHistory = socket.assigns.board_history
    newBoardHistory = [newBoard | oldBoardHistory]
    solveCallArguments = newBoardHistory |> :lists.reverse()

    latestSolution = Waffle.solve(solveCallArguments)
    IO.inspect(latestSolution, label: "latestSolution")

    socket =
      socket
      |> assign(:board, newBoard)
      |> assign(:board_history, newBoardHistory)
      |> assign(:current_fsm_state, :display_solution)
      |> assign(:previous_fsm_state, :begin_feedback_form)
      |> assign(:latest_solution, latestSolution)

    {:noreply, socket}
  end

  @spec getSolverSquareFeedbackNumber(:green | :grey | :yellow, boolean()) :: 0 | 1 | 2 | 4
  def getSolverSquareFeedbackNumber(feedback_color, is_intersection) do
    case feedback_color do
      :green -> 2
      :grey -> 0
      :yellow -> case is_intersection do
        true -> 4
        false -> 1
      end
    end
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
