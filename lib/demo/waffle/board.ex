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
            ]

  @doc """
  idx takes numbers 1-5 for both indices, NOT zero-based indices
  """
  @spec idx(Board, integer(), integer()) :: String.t()
  def idx(board, i, j) do
    outer = board.characterStrings
    inner = :lists.nth(i, outer)
    :lists.nth(j, inner)
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

  # i and j parameters must be between 1 and 5 inclusive --
  # but NOT including {2,2}, {2,4}, {4,2}, or {4,4} -- I mean I won't throw an error but this will cease to be a valid board
  @spec swap(Board, integer(), integer(), integer(), integer()) :: Board
  def swap(board, leftI, leftJ, rightI, rightJ) do
    leftChar = idx(board, leftI, leftJ)
    rightChar = idx(board, rightI, rightJ)

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
                  _other -> idx(board, workingI, workingJ)
                end

              _other ->
                idx(board, workingI, workingJ)
            end
          end)
        end)
    }
  end
end
