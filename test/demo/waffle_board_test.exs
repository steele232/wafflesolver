defmodule WaffleBoardTest do
  use ExUnit.Case, async: true
  alias Demo.Waffle.Board

  test "Board Construction 1" do
    board = %Board{
      characterStrings: [
        ["d", "u", "e", "r", "n"],
        ["r", " ", "l", " ", "e"],
        ["i", "m", "t", "a", "e"],
        ["e", " ", "o", " ", "t"],
        ["d", "m", "v", "e", "e"]
      ]
    }
    IO.inspect(board)
    assert "duern" ==
      Board.getHorizontalWord(board, 1)
    assert "imtae" ==
      Board.getHorizontalWord(board, 2)
    assert "dmvee" ==
      Board.getHorizontalWord(board, 3)
    assert "dried" ==
      Board.getVerticalWord(board, 1)
    assert "eltov" ==
      Board.getVerticalWord(board, 2)
    assert "neete" ==
      Board.getVerticalWord(board, 3)

  end

  test "Board Construction 2" do
    board = %Board{
      characterStrings: [
        ["d", "u", "e", "r", "n"],
        ["r", " ", "l", " ", "e"],
        ["o", "m", "t", "e", "a"],
        ["i", " ", "e", " ", "t"],
        ["d", "v", "v", "e", "e"]
      ]
    }
    IO.inspect(board)
    assert "duern" ==
      Board.getHorizontalWord(board, 1)
    assert "omtea" ==
      Board.getHorizontalWord(board, 2)
    assert "dvvee" ==
      Board.getHorizontalWord(board, 3)
    assert "droid" ==
      Board.getVerticalWord(board, 1)
    assert "eltev" ==
      Board.getVerticalWord(board, 2)
    assert "neate" ==
      Board.getVerticalWord(board, 3)

    newBoard = Board.swap(board, 1, 2, 3, 1)
    assert newBoard.characterStrings == [
        ["d", "o", "e", "r", "n"],
        ["r", " ", "l", " ", "e"],
        ["u", "m", "t", "e", "a"],
        ["i", " ", "e", " ", "t"],
        ["d", "v", "v", "e", "e"]
    ]

  end




end
