defmodule Demo.Waffle.Board do
  alias Demo.Waffle.Board

  # NOTE these are lists of graphemes (strings)
  # NOTE spaces are used as null characters here
  defstruct characterStrings: [
              ["0", "0", "0", "0", "0"],
              ["0", " ", "0", " ", "0"],
              ["0", "0", "0", "0", "0"],
              ["0", " ", "0", " ", "0"],
              ["0", "0", "0", "0", "0"]
            ],
            feedbackStrings: [
              ["0", "0", "0", "0", "0"],
              ["0", " ", "0", " ", "0"],
              ["0", "0", "0", "0", "0"],
              ["0", " ", "0", " ", "0"],
              ["0", "0", "0", "0", "0"]
            ]

  @doc """
  idx takes numbers 1-5 for both indices, NOT zero-based indices
  """
  @spec charIdx(Board, integer(), integer()) :: String.t()
  def charIdx(board, i, j) do
    outer = board.characterStrings
    inner = :lists.nth(i, outer)
    :lists.nth(j, inner)
  end

  @doc """
  idx takes numbers 1-5 for both indices, NOT zero-based indices
  """
  @spec feedbackIdx(Board, integer(), integer()) :: String.t()
  def feedbackIdx(board, i, j) do
    outer = board.feedbackStrings
    inner = :lists.nth(i, outer)
    :lists.nth(j, inner)
  end

  # TODO specify this more. and .. try to handle errors more?
  @spec getIndicesFromString(binary) :: %{horizontal: binary, vertical: binary}
  def getIndicesFromString(str) do
    letters = str |> String.graphemes
    verticalIdx = :lists.nth(2, letters)
    horizontalIdx = :lists.nth(4, letters)
    %{vertical: verticalIdx, horizontal: horizontalIdx}
  end

  @doc """
  wordIdx takes numbers 1-3 as indices
  wordIdx is from top-left
  """
  @spec getHorizontalWord(Board, integer()) :: String.t()
  def getHorizontalWord(board, wordIdx) do
    idx =
      case wordIdx do
        1 -> 1
        2 -> 3
        3 -> 5
      end

    :lists.nth(idx, board.characterStrings)
    |> List.to_string()
  end

  @doc """
  wordIdx takes numbers 1-3 as indices
  wordIdx is from top-left
  """
  @spec getVerticalWord(Board, integer()) :: String.t()
  def getVerticalWord(board, wordIdx) do
    idx =
      case wordIdx do
        1 -> 1
        2 -> 3
        3 -> 5
      end

    Enum.map(
      board.characterStrings,
      fn li -> :lists.nth(idx, li) end
    )
    |> List.to_string()
  end

  @doc """
  wordIdx takes numbers 1-3 as indices
  wordIdx is from top-left
  """
  @spec getHorizontalFeedback(Board, integer()) :: String.t()
  def getHorizontalFeedback(board, wordIdx) do
    idx =
      case wordIdx do
        1 -> 1
        2 -> 3
        3 -> 5
      end

    :lists.nth(idx, board.feedbackStrings)
    |> List.to_string()
  end

  @doc """
  wordIdx takes numbers 1-3 as indices
  wordIdx is from top-left
  """
  @spec getVerticalFeedback(Board, integer()) :: String.t()
  def getVerticalFeedback(board, wordIdx) do
    idx =
      case wordIdx do
        1 -> 1
        2 -> 3
        3 -> 5
      end

    Enum.map(
      board.feedbackStrings,
      fn li -> :lists.nth(idx, li) end
    )
    |> List.to_string()
  end

  # i and j parameters must be between 1 and 5 inclusive --
  # but NOT including {2,2}, {2,4}, {4,2}, or {4,4} -- I mean I won't throw an error but this will cease to be a valid board
  @spec swap(Board, integer(), integer(), integer(), integer()) :: Board
  def swap(board, leftI, leftJ, rightI, rightJ) do
    leftChar = charIdx(board, leftI, leftJ)
    rightChar = charIdx(board, rightI, rightJ)

    # IO.inspect(board)
    # IO.inspect(leftChar)
    # IO.inspect(rightChar)

    # put rightChar on the board in position leftI, leftJ
    # put leftChar on the board in position rightI, rightJ
    updateBoard(board, leftI, leftJ, rightChar)
    |> updateBoard(rightI, rightJ, leftChar)
  end

  @spec updateBoard(Board, integer(), integer(), String.t()) :: Board
  defp updateBoard(board, i, j, newChar) do
    %Board{
      characterStrings:
        Enum.map(1..5, fn workingI ->
          Enum.map(1..5, fn workingJ ->
            case workingI do
              ^i ->
                case workingJ do
                  ^j -> newChar
                  _other -> charIdx(board, workingI, workingJ)
                end

              _other ->
                charIdx(board, workingI, workingJ)
            end
          end)
        end)
    }
  end
end
