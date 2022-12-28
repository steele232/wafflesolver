defmodule Demo.Waffle do
  alias Demo.Waffle.Board
  alias Demo.Wordle.Feedback
  alias Demo.Wordle

  @spec solve(list(Board)) :: list(%{
          hw1: [binary()],
          hw2: [binary()],
          hw3: [binary()],
          vw1: [binary()],
          vw2: [binary()],
          vw3: [binary()]
        })
  def solve(listOfBoards) do
    # TODO find the most solved word.. and then go from there
    # .  preliminary Wordle solving should not be too hard
    # .  then it's the iterating that seems more difficult for me...

    hw1Feedbacks =
      Enum.map(listOfBoards, fn b ->
        Feedback.fromStrings(
          Board.getHorizontalWord(b, 1),
          Board.getHorizontalFeedback(b, 1)
        )
      end)

    hw2Feedbacks =
      Enum.map(listOfBoards, fn b ->
        Feedback.fromStrings(
          Board.getHorizontalWord(b, 2),
          Board.getHorizontalFeedback(b, 2)
        )
      end)

    hw3Feedbacks =
      Enum.map(listOfBoards, fn b ->
        Feedback.fromStrings(
          Board.getHorizontalWord(b, 3),
          Board.getHorizontalFeedback(b, 3)
        )
      end)

    vw1Feedbacks =
      Enum.map(listOfBoards, fn b ->
        Feedback.fromStrings(
          Board.getVerticalWord(b, 1),
          Board.getVerticalFeedback(b, 1)
        )
      end)

    vw2Feedbacks =
      Enum.map(listOfBoards, fn b ->
        Feedback.fromStrings(
          Board.getVerticalWord(b, 2),
          Board.getVerticalFeedback(b, 2)
        )
      end)

    vw3Feedbacks =
      Enum.map(listOfBoards, fn b ->
        Feedback.fromStrings(
          Board.getVerticalWord(b, 3),
          Board.getVerticalFeedback(b, 3)
        )
      end)

    hw1F = Wordle.solve(hw1Feedbacks)
    hw2F = Wordle.solve(hw2Feedbacks)
    hw3F = Wordle.solve(hw3Feedbacks)
    vw1F = Wordle.solve(vw1Feedbacks)
    vw2F = Wordle.solve(vw2Feedbacks)
    vw3F = Wordle.solve(vw3Feedbacks)

    mapOfFeedbacks = %{
      hw1: hw1F,
      hw2: hw2F,
      hw3: hw3F,
      vw1: vw1F,
      vw2: vw2F,
      vw3: vw3F
    }

    # sortedList =
    # listOfSolvedWords
    # |> Enum.sort(fn left, right -> length(left) <= length(right) end)
    # |> IO.inspect()

    # TODO maybe return from this function in a map like this....
    # .  I wrote my list trimming code to use lists and thus forget where each word is... so I might need to update that..
    # IO.inspect(%{
    #   hw1: hw1F,
    #   hw2: hw2F,
    #   hw3: hw3F,
    #   vw1: vw1F,
    #   vw2: vw2F,
    #   vw3: vw3F
    # })

    lastBoard = listOfBoards |> List.last()
    firstBoard = listOfBoards |> List.first()

    IO.puts("Last board:")
    IO.inspect(lastBoard)

    trimmedMap =
      trimLongListsBasedOnKnownWords(
        getCompleteListOfCharactersAvailableOnBoard(firstBoard),
        mapOfFeedbacks
      )

    exhaustiveSearch = exhaustiveCombinationSearchOnTrimmedResults(
      trimmedMap,
      getCompleteListOfCharactersAvailableOnBoard(firstBoard)
    )
    # fall back to earlier trimmed list if exhaustive list doesn't give the right result ....
    #    TODO or determine if this is just a bad hack.... IDK.
    case exhaustiveSearch do
      [] -> [trimmedMap] #needs to be a list because that's what exhaustive search gives..
      _combinationSearchFoundSomething -> exhaustiveSearch
    end
  end

  def trimLongListsBasedOnKnownWords(completeListOfLetters, mapOfFeedbacks) do
    # find the list of known words
    # find the remaining letters
    # iterate through candidate lists and remove words if they are not achievable based on available letters

    knownWordsMap =
      Enum.filter(
        mapOfFeedbacks,
        # PERF optimize performance by not using length method
        fn {_k, list} -> length(list) == 1 end
      )
      |> Enum.into(%{})

    # usedUpLettersMap =
    # TODO similar to solving map because the letters are "remaining" or available to be used in a given word very much depends on what intersections that word has with other already-solved words !

    # usedUpLetters =
    #   knownWordsMap
    #   |> Enum.map(fn {_k, list} -> list end)
    #   |> List.flatten()
    #   |> Enum.map(&String.graphemes/1)
    #   |> List.flatten()
    # remainingLetters = completeListOfLetters -- usedUpLetters # TODO BUG if we do it this way, then we will over-exhaust letters. Letters ARE allowed to be reused in words because of word intersections !!!
    # lengthOfTotalRemainingLetters = length(remainingLetters)

    unknownWordsMap =
      Enum.filter(
        mapOfFeedbacks,
        # PERF optimize performance by not using length method
        fn {_k, list} -> length(list) != 1 end
        # TODO what happens when length(list) == 1 ?
      )
      |> Enum.into(%{})

    trimmedUnknownWordsMap =
      Enum.map(
        unknownWordsMap,
        fn {wordIdentifier, largeListOfWords} ->
          {wordIdentifier,
           Enum.filter(
             largeListOfWords,
             fn word ->
               thisWordIsPossibleGivenKnownWords(
                 word,
                 wordIdentifier,
                 knownWordsMap,
                 completeListOfLetters
               )
             end
           )}
        end
      )
      |> Enum.into(%{})

    Map.merge(knownWordsMap, trimmedUnknownWordsMap)
  end

  def getCompleteListOfCharactersAvailableOnBoard(board) do
    board.characterStrings
    |> List.flatten()
    |> Enum.filter(&(&1 != " "))
  end

  @spec thisWordIsPossibleGivenKnownWords(binary, :hw1 | :hw2 | :hw3 | :vw1 | :vw2 | :vw3, map, [
          binary
        ]) :: boolean
  def thisWordIsPossibleGivenKnownWords(
        word,
        wordIdentifier,
        knownWordsMap,
        completeListOfLetters
      ) do
    # almost called this val: intersectingCharsThatAreKnownAndIDontWantToMarkAsBeingUsedUpDespiteTheirBeingUsedInAKnownWord =
    knownIntersections =
      case wordIdentifier do
        :hw1 ->
          %{
            c1: getChar(knownWordsMap, :vw1, 1),
            c3: getChar(knownWordsMap, :vw2, 1),
            c5: getChar(knownWordsMap, :vw3, 1)
          }

        :hw2 ->
          %{
            c1: getChar(knownWordsMap, :vw1, 3),
            c3: getChar(knownWordsMap, :vw2, 3),
            c5: getChar(knownWordsMap, :vw3, 3)
          }

        :hw3 ->
          %{
            c1: getChar(knownWordsMap, :vw1, 5),
            c3: getChar(knownWordsMap, :vw2, 5),
            c5: getChar(knownWordsMap, :vw3, 5)
          }

        :vw1 ->
          %{
            c1: getChar(knownWordsMap, :hw1, 1),
            c3: getChar(knownWordsMap, :hw2, 1),
            c5: getChar(knownWordsMap, :hw3, 1)
          }

        :vw2 ->
          %{
            c1: getChar(knownWordsMap, :hw1, 3),
            c3: getChar(knownWordsMap, :hw2, 3),
            c5: getChar(knownWordsMap, :hw3, 3)
          }

        :vw3 ->
          %{
            c1: getChar(knownWordsMap, :hw1, 5),
            c3: getChar(knownWordsMap, :hw2, 5),
            c5: getChar(knownWordsMap, :hw3, 5)
          }
      end

    usedUpLetters =
      knownWordsMap
      |> Enum.map(fn {_k, list} -> list end)
      |> List.flatten()
      |> Enum.map(&String.graphemes/1)
      |> List.flatten()

    remainingLetters = completeListOfLetters -- usedUpLetters
    knownIntersectionsList = knownIntersections |> Enum.map(fn {_k, v} -> v end) |> List.flatten()
    availableLettersList = remainingLetters ++ knownIntersectionsList

    # check the remaining letters thing ...
    lengthOfCharsAvailableForThisWord = length(availableLettersList)
    thisWordsChars = word |> String.graphemes()

    fitsRemainingLetters =
      lengthOfCharsAvailableForThisWord - 5 == length(availableLettersList -- thisWordsChars)

    # THEN check if word matches knownIntersections...
    fitsKnownIntersections =
      Enum.all?(
        knownIntersections,
        fn {k, v} ->
          nil

          case v do
            [] ->
              true

            [charBin] ->
              case k do
                :c1 -> :lists.nth(1, thisWordsChars) == charBin
                :c3 -> :lists.nth(3, thisWordsChars) == charBin
                :c5 -> :lists.nth(5, thisWordsChars) == charBin
              end
          end
        end
      )

    fitsRemainingLetters and fitsKnownIntersections
  end

  @spec getChar(map, atom, integer) :: [binary]
  def getChar(knownWordMap, wordIdentifier, n) do
    case Map.has_key?(knownWordMap, wordIdentifier) do
      true ->
        %{^wordIdentifier => [word]} = knownWordMap
        chars = word |> String.graphemes()
        [:lists.nth(n, chars)]

      false ->
        # this will be List.flatten'ed in the usage
        []
    end
  end

  @spec exhaustiveCombinationSearchOnTrimmedResults(
          %{hw1: list, hw2: list, hw3: list, vw1: list, vw2: list, vw3: list},
          list(binary)
        ) :: list(%{
          hw1: [binary()],
          hw2: [binary()],
          hw3: [binary()],
          vw1: [binary()],
          vw2: [binary()],
          vw3: [binary()]
        })
  def exhaustiveCombinationSearchOnTrimmedResults(
        trimmedMap = %{hw1: hw1, hw2: hw2, hw3: hw3, vw1: vw1, vw2: vw2, vw3: vw3},
        listOfCharactersAvailableOnBoard
      ) do
    # first just count how many combinations there should be
    IO.puts("Num Possible Combinations")

    numCombos =
      Enum.map(trimmedMap, fn {_k, v} -> length(v) end)
      # |> IO.inspect()
      |> Enum.reduce(0, fn accum, elem ->
        cond do
          elem > 1 -> accum * elem
          true -> accum
        end
      end)

    IO.inspect(numCombos)

    # TODO DECIDE what to do when an empty list is passed in for one of the words
    # THROW / QUIT for now...

    # TODO try to find all possible combinations ...
    # I am... not sure about this... I need to generate and traverse a tree basically and then return a list of possible boards ...
    # TODO just do a really crappy version for now and then we can optimize it later..
    lenHw1 = length(hw1)
    lenHw2 = length(hw2)
    lenHw3 = length(hw3)
    lenVw1 = length(vw1)
    lenVw2 = length(vw2)
    lenVw3 = length(vw3)

    cond do
      lenHw1 == 0 -> []
      lenHw2 == 0 -> []
      lenHw3 == 0 -> []
      lenVw1 == 0 -> []
      lenVw2 == 0 -> []
      lenVw3 == 0 -> []
      true ->
        startingMap = %{}

        generatedCombinations =
          1..lenHw1
          |> Enum.map(fn hw1Idx ->
            chosenHw1 = Enum.at(hw1, hw1Idx - 1)
            hw1Map = Map.put_new(startingMap, :hw1, [chosenHw1])

            1..lenHw2
            |> Enum.map(fn hw2Idx ->
              chosenHw2 = Enum.at(hw2, hw2Idx - 1)
              hw2Map = Map.put_new(hw1Map, :hw2, [chosenHw2])

              1..lenHw3
              |> Enum.map(fn hw3Idx ->
                chosenHw3 = Enum.at(hw3, hw3Idx - 1)
                hw3Map = Map.put_new(hw2Map, :hw3, [chosenHw3])
                1..lenVw1
                |> Enum.map(fn vw1Idx ->
                  chosenVw1 = Enum.at(vw1, vw1Idx - 1)
                  vw1Map = Map.put_new(hw3Map, :vw1, [chosenVw1])

                  1..lenVw2
                  |> Enum.map(fn vw2Idx ->
                    chosenVw2 = Enum.at(vw2, vw2Idx - 1)
                    vw2Map = Map.put_new(vw1Map, :vw2, [chosenVw2])

                    1..lenVw3
                    |> Enum.map(fn vw3Idx ->
                      chosenVw3 = Enum.at(vw3, vw3Idx - 1)
                      vw3Map = Map.put_new(vw2Map, :vw3, [chosenVw3])
                      # TODO get this out somehow...
                      # .  vw3Map is what I want to get out ... at least
                      # .   I want vw3Map to be a variable that I can call
                      # .  to check and see if it's a valid solution
                      # .  also I want it as a list so that I can check if
                      # .  I got the right amount of combinations out of here
                    end)
                  end)
                end)
              end)
            end)
          end)
          |> List.flatten()
          # |> IO.inspect()

        # IO.puts("Length of combinations is ..")
        length(generatedCombinations)
        # |> IO.inspect()

        # check all of the generated possible combinations
        generatedCombinations
        |> Enum.filter(fn combination -> checkPossibleBoard(combination, listOfCharactersAvailableOnBoard) end)
        # returns list of possible answers :)
    end
  end

  @spec checkPossibleBoard(
          %{hw1: [binary], hw2: [binary], hw3: [binary], vw1: [binary], vw2: [binary], vw3: [binary]},
          list(binary)
        ) :: boolean()
  def checkPossibleBoard(
        onePossibleAnswerMap = %{hw1: [hw1], hw2: [hw2], hw3: [hw3], vw1: [vw1], vw2: [vw2], vw3: [vw3]},
        listOfCharactersOnBoard
      ) do

    # IO.puts "one possible answer map"
    # IO.inspect(onePossibleAnswerMap)
    # IO.puts "listOfCharactersOnBoard = "
    # IO.inspect(listOfCharactersOnBoard)

    # return early-escaping-AND-clause
    # thisWordIsPossibleGivenKnownWords(
    #   hw1,
    #   :hw1,
    #   onePossibleAnswerMap,
    #   listOfCharactersOnBoard
    # ) and
    # thisWordIsPossibleGivenKnownWords(
    #   hw2,
    #   :hw2,
    #   onePossibleAnswerMap,
    #   listOfCharactersOnBoard
    # ) and
    # thisWordIsPossibleGivenKnownWords(
    #   hw3,
    #   :hw3,
    #   onePossibleAnswerMap,
    #   listOfCharactersOnBoard
    # ) and
    # thisWordIsPossibleGivenKnownWords(
    #   vw1,
    #   :hw1,
    #   onePossibleAnswerMap,
    #   listOfCharactersOnBoard
    # ) and
    # thisWordIsPossibleGivenKnownWords(
    #   vw2,
    #   :hw1,
    #   onePossibleAnswerMap,
    #   listOfCharactersOnBoard
    # ) and
    # thisWordIsPossibleGivenKnownWords(
    #   vw3,
    #   :hw1,
    #   onePossibleAnswerMap,
    #   listOfCharactersOnBoard
    # ) and
    0 == length(listOfCharactersOnBoard -- (List.flatten([
      String.graphemes(hw1),
      [String.at(vw1, 1), String.at(vw2, 1), String.at(vw3, 1)], # 2nd row
      String.graphemes(hw2),
      [String.at(vw1, 3), String.at(vw2, 3), String.at(vw3, 3)], # 4th row
      String.graphemes(hw3)
    ])
    # |> IO.inspect()
    ))
  end
end
