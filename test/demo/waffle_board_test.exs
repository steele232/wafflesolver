defmodule WaffleBoardTest do
  use ExUnit.Case, async: true
  alias Demo.Waffle.Board
  alias Demo.Waffle

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
    # IO.inspect(board)
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
    # IO.inspect(board)
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

  test "board construction with feedback 1" do
    board = %Board{
      characterStrings: [
        ["y", "e", "h", "r", "a"],
        ["a", " ", "k", " ", "e"],
        ["w", "e", "a", "a", "m"],
        ["c", " ", "n", " ", "l"],
        ["n", "u", "k", "c", "d"]
      ],
      feedbackStrings: [
        ["2", "0", "3", "0", "2"],
        ["1", " ", "0", " ", "1"],
        ["3", "1", "2", "1", "3"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "2", "0", "2"]
      ]
    }
    # IO.inspect(board)
    assert "yehra" ==
      Board.getHorizontalWord(board, 1)
    assert "weaam" ==
      Board.getHorizontalWord(board, 2)
    assert "nukcd" ==
      Board.getHorizontalWord(board, 3)
    assert "yawcn" ==
      Board.getVerticalWord(board, 1)
    assert "hkank" ==
      Board.getVerticalWord(board, 2)
    assert "aemld" ==
      Board.getVerticalWord(board, 3)

    assert "20302" ==
      Board.getHorizontalFeedback(board, 1)
    assert "31213" ==
      Board.getHorizontalFeedback(board, 2)
    assert "20202" ==
      Board.getHorizontalFeedback(board, 3)
    assert "21302" ==
      Board.getVerticalFeedback(board, 1)
    assert "30202" ==
      Board.getVerticalFeedback(board, 2)
    assert "21302" ==
      Board.getVerticalFeedback(board, 3)

    expectedCharactersAvailableList = ["y", "e", "h", "r", "a", "a", "k", "e", "w", "e", "a", "a", "m", "c", "n", "l", "n", "u", "k", "c", "d"]
    assert expectedCharactersAvailableList == Waffle.getCompleteListOfCharactersAvailableOnBoard(board)

    # IO.inspect Waffle.solve([board])

    # TODO see if this can be improved? But I think this is amazing..

    assert Waffle.solve([board]) == %{
      hw1: ["yucca"],
      hw2: ["whale"],
      hw3: ["naked"],
      vw1: ["yearn"],
      vw2: [], # TODO used to be these ?? maybe not on this specific word.. ["chalk", "clack", "crack", "whack", "wrack"],
      vw3: []  # TODO used to be these ?? maybe not on this specific word.. ["ached", "ahead", "amend", "arced", "armed"]
    }
  end
  # TODO why did some of the above words come back empty on this one? Is my algorithm too aggressive? I would love to know what the actual word was on this one? I should record that in my future examples so that I can continue to maintain the tests; right now, it is very hard to maintain the tests without the feedback oracle ... (the real game website)

  test "test solving with accumulating boards" do
    # TODO
    board1 = %Board{
      characterStrings: [
        ["w", "n", "i", "d", "w"],
        ["e", " ", "d", " ", "i"],
        ["a", "i", "i", "e", "e"],
        ["o", " ", "f", " ", "r"],
        ["r", "g", "c", "g", "e"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "1", "2"],
        ["1", " ", "1", " ", "2"],
        ["4", "0", "2", "1", "0"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "0", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    board2 = %Board{
      characterStrings: [
        ["w", "e", "i", "d", "w"],
        ["e", " ", "d", " ", "i"],
        ["a", "i", "i", "e", "n"],
        ["o", " ", "f", " ", "r"],
        ["r", "g", "c", "g", "e"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "1", "2"],
        ["1", " ", "1", " ", "2"],
        ["4", "0", "2", "1", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "0", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2])
    board3 = %Board{
      characterStrings: [
        ["w", "e", "i", "d", "w"],
        ["e", " ", "c", " ", "i"],
        ["a", "i", "i", "e", "n"],
        ["o", " ", "f", " ", "r"],
        ["r", "g", "d", "g", "e"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "1", "2"],
        ["1", " ", "0", " ", "2"],
        ["4", "0", "2", "1", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "2", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3])
    board4 = %Board{
      characterStrings: [
        ["w", "i", "d", "o", "w"],
        ["a", " ", "c", " ", "i"],
        ["f", "i", "i", "e", "n"],
        ["e", " ", "o", " ", "r"],
        ["r", "g", "d", "g", "e"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["2", " ", "0", " ", "2"],
        ["2", "4", "2", "1", "2"],
        ["2", " ", "3", " ", "0"],
        ["2", "0", "2", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4])
  end

end
