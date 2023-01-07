defmodule WaffleBoardTest do
  use ExUnit.Case, async: true
  alias Demo.Waffle.Board
  alias Demo.Waffle
  alias Demo.Wordle
  alias Demo.Wordle.Feedback

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
    assert "y" == Board.charIdx(board, 1, 1)
    assert "a" == Board.charIdx(board, 2, 1)
    assert "w" == Board.charIdx(board, 3, 1)
    assert "e" == Board.charIdx(board, 1, 2)
    assert "h" == Board.charIdx(board, 1, 3)
    assert "r" == Board.charIdx(board, 1, 4)
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

    assert Waffle.solve([board]) == [%{
      hw1: ["yucca"],
      hw2: ["awake"], #  used to be "whale" but I fixed a bug
      hw3: ["naked"],
      vw1: ["yearn"],
      vw2: ["chalk"], # used to be [] bug I fixed a bug
      vw3: ["ahead"]  # used to be [] but I fixed a bug
    }]
  end

  test "test 2022 Nov 7 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["g", "n", "v", "l", "t"],
        ["w", " ", "u", " ", "i"],
        ["m", "y", "o", "r", "e"],
        ["o", " ", "s", " ", "a"],
        ["t", "s", "e", "r", "t"]
      ],
      feedbackStrings: [
        ["2", "1", "4", "1", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "1", "0", "1", "2"]
      ]
    }
    board1Result = Waffle.solve([board1])
    IO.inspect board1
    assert board1 == [
      %{
        hw1: ["glint"],
        hw2: ["moose"],
        hw3: ["tryst"],
        vw1: ["gamut"],
        vw2: ["ivory"],
        vw3: ["theft"] # ??? !^
      }
    ]
    # TODO why did I get "theft" ?? There is no "h" on the board???
    board2 = %Board{
      characterStrings: [
        ["g", "n", "v", "l", "t"],
        ["a", " ", "u", " ", "i"],
        ["m", "y", "o", "r", "e"],
        ["u", " ", "s", " ", "a"],
        ["t", "s", "e", "r", "t"]
      ],
      feedbackStrings: [
        ["2", "1", "0", "1", "2"],
        ["2", " ", "2", " ", "0"],
        ["2", "0", "2", "0", "2"],
        ["2", " ", "2", " ", "1"],
        ["2", "1", "0", "1", "2"]
      ]
    }
    IO.inspect Waffle.solve([board2])

  end

  test "test 2022 Nov 8 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["l", "e", "c", "m", "t"],
        ["r", " ", "e", " ", "i"],
        ["r", "o", "t", "o", "e"],
        ["i", " ", "a", " ", "h"],
        ["t", "e", "h", "p", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "4", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["2", " ", "1", " ", "1"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])

    board2 = %Board{
      characterStrings: [
        ["l", "e", "a", "m", "t"],
        ["r", " ", "e", " ", "i"],
        ["r", "o", "t", "o", "e"],
        ["i", " ", "c", " ", "h"],
        ["t", "e", "h", "p", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["2", " ", "1", " ", "1"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect
    boardResults1 = Waffle.solve([board1, board2])
    [
      %{
        hw1: ["leapt"],
        hw2: ["meter"],
        hw3: ["throw"],
        vw1: ["licit"], # TODO how it possible for this and the next one to be possible answers!!!
        vw2: ["actor"],
        vw3: ["threw"]
      },
      %{
        hw1: ["leapt"],
        hw2: ["meter"],
        hw3: ["throw"],
        vw1: ["limit"],
        vw2: ["actor"],
        vw3: ["threw"]
      }
    ]
    # NOTE We should know be doubly sure about
    # leapt and actor. all others probably unchanged..
    board3 = %Board{
      characterStrings: [
        ["l", "e", "a", "m", "t"],
        ["r", " ", "e", " ", "i"],
        ["e", "o", "t", "o", "r"],
        ["i", " ", "c", " ", "h"],
        ["t", "e", "h", "p", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["4", "0", "2", "0", "2"],
        ["2", " ", "1", " ", "1"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3])
    # NOTE we should be doubly sure about threw/throw on vw3
    # vw1 was either licit or limit so e is not that word. E must be in hw2, our most questionable word...
    # NVMD (not) bug I think; vw1 knows l will be in the 1 position so it should be unavailable to hw2. There is no L available to be in the hw2, because vw1 is known to have l in char position 1, and NOT in position 3...
    board4 = %Board{
      characterStrings: [
        ["l", "e", "a", "e", "t"],
        ["r", " ", "e", " ", "i"],
        ["m", "o", "t", "o", "r"],
        ["i", " ", "c", " ", "h"],
        ["t", "e", "h", "p", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "2", "0", "2"],
        ["2", " ", "1", " ", "1"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4])
    # NOTE a pretty good situation here at 12-swaps-remaining !
    foundSoFar = %{
      hw1: ["leapt"],
      hw2: ["mater", "meter"],
      hw3: ["throw"],
      vw1: ["limit"],
      vw2: ["actor"],
      vw3: ["threw", "throw"]
    }
    board5 = %Board{
      characterStrings: [
        ["l", "e", "a", "e", "t"],
        ["r", " ", "e", " ", "h"],
        ["m", "o", "t", "o", "r"],
        ["i", " ", "c", " ", "i"],
        ["t", "e", "h", "p", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "0", "2"],
        ["0", " ", "0", " ", "2"],
        ["2", "0", "2", "0", "2"],
        ["2", " ", "1", " ", "0"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5])
    board6 = %Board{
      characterStrings: [
        ["l", "e", "a", "p", "t"],
        ["r", " ", "e", " ", "h"],
        ["m", "o", "t", "o", "r"],
        ["i", " ", "c", " ", "i"],
        ["t", "e", "h", "e", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["0", " ", "0", " ", "2"],
        ["2", "0", "2", "0", "2"],
        ["2", " ", "1", " ", "0"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5, board6])
    # TODO a bug found -- # TODO this is probably fixed now
    brokeMyselfEventually = %{
      hw1: ["leapt"],
      hw2: [],
      hw3: ["throw"],
      vw1: ["limit"],
      vw2: [],
      vw3: ["threw", "throw"]
    }

    board11 = %Board{
      characterStrings: [
        ["l", "e", "a", "p", "t"],
        ["i", " ", "c", " ", "h"],
        ["m", "e", "t", "e", "r"],
        ["i", " ", "o", " ", "e"],
        ["t", "h", "r", "o", "w"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["2", " ", "2", " ", "2"],
        ["2", "2", "2", "2", "2"],
        ["2", " ", "2", " ", "2"],
        ["2", "2", "2", "2", "2"]
      ]
    }
    # NOTE none of these are broken in the way that boards 1-6 was ...
    IO.inspect Waffle.solve([board11])
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5, board11])
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5, board6, board11])
  end

  test "test 2022 Nov 9 #292 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["b", "m", "a", "t", "d"],
        ["m", " ", "s", " ", "a"],
        ["r", "p", "a", "w", "i"],
        ["l", " ", "l", " ", "m"],
        ["e", "z", "l", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["0", " ", "1", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["1", " ", "0", " ", "1"],
        ["2", "0", "0", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    # NOTE lots of possibilities...
    %{
      hw1: ["baled", "bared", "based", "bayed", "biped", "bleed", "bread", "breed"],
      hw2: ["abase", "abate", "alarm", "amaze", "arabs", "beads", "beady", "beams",
       "bears", "beard", "beast", "beats", "bialy", "blade", "blame", "blare",
       "blase", "blast", "blaze", "brads", "braes", "braid", "brats", "brays",
       "braze", "deals", "dealt", "dears", "deary", "dials", "diary", "drabs",
       "drams", "drama", "drays", "elate", "erase", "imams", "irate", "italy",
       "leads", "lease", "least", "liars", "llama", "meads", "meals", "meats"],
       # AND MORE
      hw3: ["empty"],
      vw1: ["belie", "blade", "blare", "blase", "blaze"],
      vw2: ["beads", "beams", "bears", "beast", "beats", "brads", "braes", "brats",
       "brays", "dears", "drabs", "drams", "draws", "drays", "erase", "imams",
       "meads", "meats", "pears", "peats", "prams", "prays", "reads", "reams",
       "reaps", "seamy", "smart", "spade", "spare", "spate", "staid", "stair",
       "stamp", "stare", "swami", "swamp", "sward", "swarm", "teams", "tears",
       "tease", "trams", "traps", "trays", "wears"],
       # AND MORE
      vw3: ["dimly"]
    }
    # NOTE I know that hw1 cannot be "baled" because there are no "l"s in the vw2 .. seems there are a lot of interdependencies we know with the "0"s. That seems pretty useful ?
    board2 = %Board{
      characterStrings: [
        ["b", "m", "a", "t", "d"],
        ["l", " ", "s", " ", "a"],
        ["r", "p", "a", "w", "i"],
        ["m", " ", "l", " ", "m"],
        ["e", "z", "l", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["2", " ", "1", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["0", " ", "0", " ", "1"],
        ["2", "0", "0", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2])
    board3 = %Board{
      characterStrings: [
        ["b", "m", "a", "t", "d"],
        ["l", " ", "s", " ", "a"],
        ["m", "p", "a", "w", "i"],
        ["r", " ", "l", " ", "m"],
        ["e", "z", "l", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["2", " ", "1", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["0", " ", "0", " ", "1"],
        ["2", "0", "0", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3])
    board4 = %Board{
      characterStrings: [
        ["b", "m", "a", "t", "d"],
        ["l", " ", "s", " ", "a"],
        ["m", "p", "a", "w", "i"],
        ["z", " ", "l", " ", "m"],
        ["e", "r", "l", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["2", " ", "1", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["2", " ", "0", " ", "1"],
        ["2", "0", "0", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4])
    # NOTE I did a couple really good synergy swaps here....
    board5 = %Board{
      characterStrings: [
        ["b", "m", "a", "t", "d"],
        ["l", " ", "s", " ", "i"],
        ["a", "p", "a", "w", "m"],
        ["z", " ", "m", " ", "l"],
        ["e", "r", "l", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["2", " ", "1", " ", "2"],
        ["2", "0", "2", "0", "2"],
        ["2", " ", "2", " ", "2"],
        ["2", "0", "0", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5])
    # NOTE we ... lost track of what hw1 was.. but we otherwise made great progress... a bug in the wordle module then? -- something about having too much feedback XD
    newFound = %{
      hw1: [], # used to say   hw1: ["baled", "bared", "based", "bayed", "biped", "bread"],
      # so based on the previous and knowing that vw2 starts with an "s" or a "t", then I know that hw1 must be "based"
      hw2: ["alarm"],
      hw3: ["empty"],
      vw1: ["blaze"],
      vw2: ["stamp", "swamp", "teams"], # it ended up being "swamp" and I think I could've figured that out based on available characters.. ??
      vw3: ["dimly"]
    }

    # NOTE I ended up getting 3 stars on this one. Possibly because of bad swapping but I did have several win-win/0->2,0->2 swaps so I felt OK about the swaps. But I'm sure that I could've found a better path programmatically somewhere along the chain, either earlier during uncertainty or later during certainty

  end
  test "test 2022 Nov 10 #293 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["g", "r", "t", "t", "n"],
        ["s", " ", "i", " ", "e"],
        ["x", "e", "i", "d", "u"],
        ["c", " ", "t", " ", "r"],
        ["d", "t", "e", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "4", "0", "2"],
        ["0", " ", "1", " ", "0"],
        ["4", "1", "2", "0", "4"],
        ["0", " ", "0", " ", "0"],
        ["2", "1", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    # NOTE "guyed" is not really an option on vw1 because it the only available "y" in the whole board is known to be green on vw3
    foundThisRun = %{
      hw1: ["green"],
      hw2: ["crier", "cries", "exist", "exits", "guise", "icier", "suite", "trice",
       "tries", "trine", "trite", "unite", "urine"],
      hw3: ["dirty", "ditty", "dusty"],
      vw1: ["greed", "grind", "guyed"],
      vw2: ["cried", "crier", "cries", "cuing", "deign", "dried", "drier", "dries",
       "dying", "grids", "grins", "grind", "icier", "icing", "reign", "reins",
       "ruins", "ruing", "suing", "using"],
      vw3: ["nutty"]
    }
    board2 = %Board{
      characterStrings: [
        ["g", "r", "t", "t", "n"],
        ["s", " ", "i", " ", "u"],
        ["x", "e", "i", "d", "e"],
        ["c", " ", "t", " ", "r"],
        ["d", "t", "e", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "4", "0", "2"],
        ["0", " ", "1", " ", "2"],
        ["4", "1", "2", "0", "0"],
        ["0", " ", "0", " ", "0"],
        ["2", "1", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2])
    # NOTE I can actually understand why hw2 no longer has any available options ..
    # because all the previous possibilities are destroyed by the known non-existence of "e"
    latestFound = %{
      hw1: ["green"],
      hw2: [],
      hw3: ["dirty", "ditty"],
      vw1: ["greed"],
      vw2: ["cried", "crier", "cries", "dried", "drier", "dries", "grids", "icier"],
      vw3: ["nutty"]
    }
    board3 = %Board{
      characterStrings: [
        ["g", "r", "e", "t", "n"],
        ["s", " ", "i", " ", "u"],
        ["x", "e", "i", "d", "t"],
        ["c", " ", "t", " ", "r"],
        ["d", "t", "e", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "0", "2"],
        ["0", " ", "1", " ", "2"],
        ["4", "1", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "1", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3])
    # NOTE we lost a lot there... but I can understand why have (1,3) an "e" creates problems :)
    latestFound = %{
      hw1: ["green"],
      hw2: [],
      hw3: ["dirty", "ditty"],
      vw1: ["greed"],
      vw2: [],
      vw3: ["nutty"]
    }
    board4 = %Board{
      characterStrings: [
        ["g", "r", "e", "e", "n"],
        ["s", " ", "i", " ", "u"],
        ["x", "e", "i", "d", "t"],
        ["c", " ", "t", " ", "r"],
        ["d", "t", "e", "t", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["0", " ", "1", " ", "2"],
        ["4", "1", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "1", "4", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4])
    # NOTE the above was a good reliable move but I don't know if it will give me any more information
    latestFound = %{
      hw1: ["green"],
      hw2: [],
      hw3: ["dirty", "ditty"],
      vw1: ["greed"],
      vw2: [],
      vw3: ["nutty"]
    }
    # Wow. looks like we destroyed the solver
    board5 = %Board{
      characterStrings: [
        ["g", "r", "e", "e", "n"],
        ["s", " ", "i", " ", "u"],
        ["x", "e", "i", "d", "t"],
        ["c", " ", "e", " ", "r"],
        ["d", "t", "t", "t", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["0", " ", "1", " ", "2"],
        ["4", "1", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "4", "2", "2", "2"] # TODO use a positional blackList instead of 0 because there are other "t"s in the word, in fact 2 of them! so we don't want to break the solver by saying there are no "t"s -- maybe this is the way I have broken my solver in other places as well. IDK ?
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5])
    # NOTE the above was a good reliable move and it should give me some good information
    latestFound = %{
      hw1: ["green"],
      hw2: [],
      hw3: ["ditty"],
      vw1: ["greed"],
      vw2: ["edict", "exist"],
      vw3: ["nutty"]
    }
    # okay sweet, hw2 is back in business. Either exist or edict, but vw1 is known to be greed so vw1 won't use that potential x "4" in the first position of hw2; so x is free to be used by hw2 -- in fact it must be, so we have definitely solved hw2
    board6 = %Board{
      characterStrings: [
        ["g", "r", "e", "e", "n"],
        ["s", " ", "i", " ", "u"],
        ["e", "x", "i", "d", "t"],
        ["c", " ", "e", " ", "r"],
        ["d", "t", "t", "t", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["0", " ", "1", " ", "2"],
        ["2", "2", "2", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["2", "4", "2", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5, board6])
    # that was a good nice easy swap. The rest of everything is known so we are just down to swapping end-game
    latestFound = %{
      hw1: ["green"],
      hw2: ["exist"],
      hw3: [], # "ditty"
      vw1: ["greed"],
      vw2: ["edict"],
      vw3: ["nutty"]
    }
    board7 = %Board{
      characterStrings: [
        ["g", "r", "e", "e", "n"],
        ["s", " ", "i", " ", "u"],
        ["e", "x", "i", "d", "t"],
        ["e", " ", "c", " ", "r"],
        ["d", "t", "t", "t", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "2", "2", "2"],
        ["0", " ", "1", " ", "2"],
        ["2", "2", "2", "0", "2"],
        ["2", " ", "2", " ", "0"],
        ["2", "4", "2", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3, board4, board5, board6, board7])
    latestFound = %{
      hw1: ["green"],
      hw2: ["exist"],
      hw3: [], # ditty
      vw1: ["greed"],
      vw2: ["edict"],
      vw3: ["nutty"]
    }
    # NOTE I got to work on swap-paths and I found at least one useful pattern ..
  end

  test "test 2022 Nov 12 #295 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["n", "n", "t", "h", "y"],
        ["s", " ", "a", " ", "w"],
        ["a", "u", "o", "r", "t"],
        ["k", " ", "s", " ", "a"],
        ["l", "a", "m", "m", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["1", " ", "0", " ", "0"],
        ["4", "0", "2", "2", "4"],
        ["0", " ", "1", " ", "0"],
        ["2", "2", "0", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    firstFound = %{
      hw1: ["nasty", "noway"],
      hw2: ["storm"],
      hw3: ["lanky"],
      vw1: ["nasal"],
      vw2: ["knots", "knows", "shorn", "short", "shown", "snort", "stork", "sworn"],
      vw3: ["yummy"]
    }
    # NOTE WOW I should be able to solve this immediately...
    # vw2 has the most, and it must hinge on hw1 because all the others are solved ....
    # hw1 is nasty or noway....
    # vw2 depends on hw1 for character 3
    # so vw2 starts with s or w ....
    # w is not an options so it must be s
    options = ["shorn", "short", "shown", "snort", "stork", "sworn"]

    # So... this is a practice run since I'm just going to run the thing to give me more feedback...
    # I'm just being lazy and maybe it won't save me any energy.... :( )

    # The only one that uses a "w" is "sworn" and ooh actually "shown" and.. the only difference on those is "r" and "h" as far as used words. ....
    # actually I can check hw2 to see about 3rd character in vw2
    # and hw3.get(3) is "o" ... crap both sworn and shown have o as their middle character.
    # did "availableCharacters" analysis and found that "shown" will be the right word for vw2
    myFoundWords = %{
      hw1: ["nasty"],
      hw2: ["storm"],
      hw3: ["lanky"],
      vw1: ["nasal"],
      vw2: ["shown"],
      vw3: ["yummy"]
    }



  end

  test "test 2022 Nov 14 #297 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["g", "a", "c", "f", "t"],
        ["p", " ", "o", " ", "e"],
        ["s", "u", "t", "h", "r"],
        ["r", " ", "p", " ", "o"],
        ["e", "c", "o", "d", "h"]
      ],
      feedbackStrings: [
        ["2", "0", "0", "0", "2"],
        ["1", " ", "1", " ", "0"],
        ["0", "0", "2", "0", "2"],
        ["1", " ", "0", " ", "1"],
        ["2", "1", "2", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    foundImmediately = %{
      hw1: ["ghost", "grout", "guest"],
      hw2: [], # TODO not sure how I got zero on this... A top priority on this would be finding the correct word here.
      hw3: ["epoch"],
      vw1: ["grape", "grope"], # TODO looking at the board I could see that all the "o"s were 1's or 2's and so they could be found to be unavailable...
      vw2: ["outdo", "outgo"],
      vw3: ["torah", "torch"]
    }

    board3 = %Board{
      characterStrings: [
        ["g", "s", "c", "f", "t"],
        ["r", " ", "o", " ", "e"],
        ["a", "u", "t", "h", "r"],
        ["p", " ", "p", " ", "o"],
        ["e", "c", "o", "d", "h"]
      ],
      feedbackStrings: [
        ["2", "1", "0", "0", "2"],
        ["2", " ", "1", " ", "0"],
        ["2", "0", "2", "0", "2"],
        ["2", " ", "0", " ", "1"],
        ["2", "1", "2", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board3])
    foundAfterTwoSwaps = %{
      hw1: ["ghost"],
      hw2: [], # TODO not sure why I get nothing here..
      hw3: ["epoch"],
      vw1: ["grape"],
      vw2: ["outdo"],
      vw3: ["torch"]
    }
    # NICE I know all of them but one now after 2 absolutely necessary swaps...
    # NOTE I wonder if board3 alone will get us hw2?
    IO.inspect Waffle.solve([board3])
    # NOPE I see the same thing as above.
    # ... hmm this will prevent us from straight calculating the swaps needed...

    board6ish = %Board{
      characterStrings: [
        ["g", "s", "e", "f", "t"],
        ["r", " ", "o", " ", "o"],
        ["a", "u", "t", "h", "r"],
        ["p", " ", "d", " ", "c"],
        ["e", "p", "o", "c", "h"]
      ],
      feedbackStrings: [
        ["2", "0", "0", "0", "2"],
        ["2", " ", "1", " ", "2"],
        ["2", "0", "2", "h", "2"],
        ["2", " ", "2", " ", "2"],
        ["2", "2", "2", "2", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board3, board6ish])

    # TODO fix bug... "f" got lost and so it thought it was "actor" even though it was "after" .. ?
    # TODO also I think I have mis-entered one of them; it was "0" but I inputted it as a "2" -- the "h" on (3,4) -- I changed it halfway through this testing process (went back and changed it) and so I'm not sure if these were quite right...
    # ULTIMATELY it was "after" .. ? I don't know why I never saw "f" in the answers...
    finalAnswer = %{
      hw1: ["ghost"],
      hw2: ["after"], # TODO not sure why I get nothing here..
      hw3: ["epoch"],
      vw1: ["grape"],
      vw2: ["outdo"],
      vw3: ["torch"]
    }
    # I got a 4-star out of this one... It was a little hairy on the swaps at the end...
  end


  test "test 2022 Nov 15 #298 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["c", "r", "o", "u", "t"],
        ["o", " ", "u", " ", "b"],
        ["a", "i", "c", "u", "a"],
        ["n", " ", "t", " ", "t"],
        ["c", "n", "a", "g", "y"]
      ],
      feedbackStrings: [
        ["2", "1", "4", "1", "2"],
        ["0", " ", "1", " ", "0"],
        ["4", "0", "2", "0", "4"],
        ["0", " ", "1", " ", "0"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    foundImmediately = %{
      hw1: ["court"],
      hw2: ["bacon", "cacao"], # NOTE this should be "bacon" based on availability of characters
      hw3: ["catty"],
      vw1: [], # NOTE I should be able to figure this probably
      vw2: ["uncut"],
      vw3: ["tangy"]
    }
    vw1Manually = Wordle.solve([Feedback.fromStrings("cobnc", "20202")])
    IO.inspect(vw1Manually)
    foundvw1Manually = "cubic" # !! Woohoo!!

    # eventually, I would love to be able to
    # just call a method now:
    # shortestPath = shortestPathToAllGreen(foundImmediately) # returns list of Swaps, length of 15 or fewer hopefully..

    # will I need to call a Java library for this? How can I call GenJava ??
    # apache Jenna ?

    # WOOHOO! 5 STARS!!
    # using some on-paper analysis, I was able to get 5 stars!!!
    # INDEED, noting the repeated letters needing swaps helped me get an optimal swapping plan
    # ANY win-win swaps without repeated letters are winners. If you can get a win-win on a repeated letter, it is probably the right path...
    # cycles without repeated letters are easy-ish to identify and they have basically one worst/best solution

  end

  test "test 2022 Nov 17 #300 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["a", "g", "d", "r", "m"],
        ["l", " ", "r", " ", "u"],
        ["e", "i", "a", "n", "e"],
        ["u", " ", "l", " ", "o"],
        ["e", "i", "b", "r", "r"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["0", " ", "1", " ", "0"],
        ["0", "1", "2", "1", "0"],
        ["2", " ", "0", " ", "2"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    foundImmediately = %{
      hw1: ["abeam", "album"],
      hw2: ["grain"],
      hw3: ["elder"],
      vw1: ["argue"],
      vw2: ["beard", "board", "rearm"],
      vw3: ["manor", "minor"]
    }
    # NOTE ... two U's available .. so I think hw1 = album, none of the other flex/possible words will use up that second "u"
    hw1Manually = Wordle.solve([Feedback.fromStrings("agdrm", "20402"), Feedback.fromStrings("agdum", "20422")])
    IO.inspect(hw1Manually) # ["album", "annum"]
    vw2Manually = Wordle.solve([Feedback.fromStrings("dralb", "11201")])
    IO.inspect(vw2Manually) # ["beard", "board"]

    # TODO I should be able to figure this out ... with some of the helper functions I already have available..
    # yeah here it is..
    manuallyDoItPlease = Waffle.trimLongListsBasedOnKnownWords(
      Waffle.getCompleteListOfCharactersAvailableOnBoard(board1),
      %{
        hw1: ["album"],
        hw2: ["grain"],
        hw3: ["elder"],
        vw1: ["argue"],
        vw2: ["beard", "board"],
        vw3: ["manor", "minor"]
      }
    )
    IO.inspect(manuallyDoItPlease)
    # SUCCESS !!!o
    foundImmediatelyWithBrainHelp = %{
      hw1: ["album"],
      hw2: ["grain"],
      hw3: ["elder"],
      vw1: ["argue"],
      vw2: ["board"], #OOPS it turned out to be "beard" -- we actal did have enough "e"s because we had "argue" and "elder" shared an "e"
      vw3: ["minor"]
    }


    # eventually, I would love to be able to
    # just call a method now:
    # shortestPath = shortestPathToAllGreen(foundImmediately) # returns list of Swaps, length of 15 or fewer hopefully..

    # will I need to call a Java library for this? How can I call GenJava ??
    # apache Jenna ?

    # WOOHOO! 5 STARS!!
    # using some on-paper analysis, I was able to get 5 stars!!!
    # INDEED, noting the repeated letters needing swaps helped me get an optimal swapping plan
    # ANY win-win swaps without repeated letters are winners. If you can get a win-win on a repeated letter, it is probably the right path...
    # cycles without repeated letters are easy-ish to identify and they have basically one worst/best solution

  end

  test "test 2022 Nov 18 #301 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["w", "c", "x", "l", "e"],
        ["t", " ", "a", " ", "r"],
        ["h", "h", "g", "i", "e"],
        ["t", " ", "y", " ", "i"],
        ["h", "r", "n", "e", "a"]
      ],
      feedbackStrings: [
        ["2", "0", "0", "0", "2"],
        ["1", " ", "2", " ", "1"],
        ["4", "1", "2", "1", "0"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "4", "1", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1])
    foundImmediately = %{
      hw1: ["where"],
      hw2: ["tight"],
      hw3: ["hyena"],
      vw1: ["witch"],
      vw2: [], # OOF - also I had mistyped this somehow .. ?
      vw3: ["extra"]
    }
    board2 = %Board{
      characterStrings: [
        ["w", "c", "x", "l", "e"],
        ["h", " ", "a", " ", "r"],
        ["t", "h", "g", "i", "e"],
        ["t", " ", "y", " ", "i"],
        ["h", "r", "n", "e", "a"]
      ],
      feedbackStrings: [
        ["2", "0", "0", "0", "2"],
        ["0", " ", "2", " ", "1"],
        ["2", "1", "2", "1", "0"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "4", "1", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2])
    foundNext = %{
      hw1: ["where", "white", "withe", "write"],
      hw2: [],
      hw3: ["hyena"],
      vw1: ["witch"],
      vw2: [],
      vw3: ["extra"]
    }
    board3 = %Board{
      characterStrings: [
        ["w", "c", "x", "l", "e"],
        ["h", " ", "a", " ", "r"],
        ["t", "i", "g", "h", "e"],
        ["t", " ", "y", " ", "i"],
        ["h", "r", "n", "e", "a"]
      ],
      feedbackStrings: [
        ["2", "0", "0", "0", "2"],
        ["0", " ", "2", " ", "1"],
        ["2", "2", "2", "2", "0"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "4", "1", "2"]
      ]
    }
    IO.inspect Waffle.solve([board1, board2, board3])
    foundNext = %{
      hw1: ["where"],
      hw2: ["tight"],
      hw3: ["hyena"],
      vw1: ["witch"],
      vw2: [], # OOF it was "eagle"
      vw3: ["extra"]
    }

  end

  test "test 2022 Nov 30 #313 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["c", "o", "n", "i", "e"],
        ["w", " ", "e", " ", "r"],
        ["m", "u", "n", "r", "u"],
        ["h", " ", "o", " ", "e"],
        ["t", "h", "e", "s", "e"]
      ],
      feedbackStrings: [
        ["2", "1", "0", "0", "2"],
        ["0", " ", "1", " ", "0"],
        ["2", "1", "2", "0", "4"],
        ["0", " ", "1", " ", "0"],
        ["2", "2", "4", "0", "2"]
      ]
    }
    foundImmediately = Waffle.solve([board1])
    IO.inspect foundImmediately
    # Sweet this is a good example to do for finding all possible examples ...
    assert foundImmediately == [%{
      hw1: ["chore"],
      hw2: ["minus"],
      hw3: ["three"],
      vw1: ["comet"],
      vw2: ["owner"],
      vw3: ["ensue"]
    }]
  end

  test "test 2022 Dec 1 #314 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["p", "t", "r", "r", "o"],
        ["a", " ", "i", " ", "e"],
        ["i", "d", "e", "p", "a"],
        ["e", " ", "d", " ", "l"],
        ["r", "l", "n", "l", "y"]
      ],
      feedbackStrings: [
        ["2", "0", "4", "0", "2"],
        ["0", " ", "0", " ", "0"],
        ["4", "1", "2", "1", "4"],
        ["2", " ", "0", " ", "2"],
        ["2", "0", "0", "0", "2"]
      ]
    }
    foundImmediately = Waffle.solve([board1])
    IO.inspect foundImmediately
    # assert foundImmediately == %{
    #   hw1: ["piano"],
    #   hw2: ["plead"],
    #   hw3: ["repay", "retry"], # "retry" for sure"
    #   vw1: ["peter", "piper"], # umm.. I will let the computer find this for me.
    #   vw2: ["alert", "pleat"], # umm.. I will let the computer find this for me.
    #   vw3: ["oddly"]
    # }
    # Sweet this is a good example to do for finding all possible examples ...
    assert foundImmediately == [%{
      hw1: ["piano"],
      hw2: ["plead"],
      hw3: ["retry"],
      vw1: ["piper"],
      vw2: ["alert"],
      vw3: ["oddly"]
    }]

  end

  test "test 2022 Dec 20 #334 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["m", "a", "l", "r", "a"],
        ["n", " ", "i", " ", "a"],
        ["e", "l", "v", "n", "a"],
        ["v", " ", "a", " ", "u"],
        ["c", "i", "e", "e", "y"]
      ],
      feedbackStrings: [
        ["2", "2", "0", "0", "2"],
        ["1", " ", "0", " ", "1"],
        ["4", "1", "2", "1", "4"],
        ["0", " ", "0", " ", "0"],
        ["2", "0", "4", "0", "2"]
      ]
    }
    foundImmediately = Waffle.solve([board1])
    IO.inspect foundImmediately
    assert foundImmediately == [
      %{
        hw1: ["mania"],
        hw2: ["naval"],
        hw3: ["curvy"],
        vw1: ["manic"],
        vw2: ["never"],
        vw3: ["alley"]
      },
      %{
        hw1: ["mania"],
        hw2: ["navel"],
        hw3: ["curvy"],
        vw1: ["manic"],
        vw2: ["never"],
        vw3: ["allay"]
      }
    ]

  end

  test "test 2023 Jan 6 #351 waffle first round" do
    board1 = %Board{
      characterStrings: [
        ["g", "r", "n", "o", "h"],
        ["p", " ", "h", " ", "s"],
        ["a", "r", "h", "s", "u"], # oh i did originally typo the "s" and made it a "d" on accident
        ["t", " ", "e", " ", "e"],
        ["l", "g", "u", "o", "e"]
      ],
      feedbackStrings: [
        ["2", "2", "4", "0", "2"],
        ["0", " ", "0", " ", "1"],
        ["0", "1", "2", "0", "0"],
        ["0", " ", "2", " ", "0"],
        ["2", "1", "4", "0", "2"]
      ]
    }

    foundImmediately = Waffle.solve([board1])
    IO.inspect foundImmediately
    # TODO this is an interesting bug
    assert foundImmediately == [
      %{
        hw1: ["graph"],
        hw2: ["other"],
        hw3: ["lunge"],
        vw1: ["ghoul"],
        vw2: ["ashen"],
        vw3: ["horse"]
      },
      # %{
      #   hw1: ["graph"],
      #   hw2: ["other"],
      #   hw3: ["lunge"],
      #   vw1: ["ghoul"],
      #   vw2: ["ashes"], # NOTE ashes vs ashen
      #   vw3: ["horse"]
      # }
    ]

  end


end
