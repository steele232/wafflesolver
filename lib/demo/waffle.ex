defmodule Demo.Waffle do
  alias Demo.Waffle.Board
  alias Demo.Wordle.Feedback
  alias Demo.Wordle

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

    firstBoard = listOfBoards |> List.first()

    trimLongListsBasedOnKnownWords(
      getCompleteListOfCharactersAvailableOnBoard(firstBoard),
      mapOfFeedbacks
    )
  end

  def trimLongListsBasedOnKnownWords(completeListOfLetters, mapOfFeedbacks) do
    # find the list of known words
    # find the remaining letters
    # iterate through candidate lists and remove words if they are not achievable based on available letters

    knownWordsMap =
      Enum.filter(
        mapOfFeedbacks,
        fn {_k, list} -> length(list) == 1 end # PERF optimize performance by not using length method
      ) |> Enum.into(%{})

    usedUpLetters =
      knownWordsMap
      |> Enum.map(fn {_k, list} -> list end)
      |> List.flatten()
      |> Enum.map(&String.graphemes/1)
      |> List.flatten()
    remainingLetters = completeListOfLetters -- usedUpLetters
    lengthOfTotalRemainingLetters = length(remainingLetters)

    unknownWordsMap =
      Enum.filter(
        mapOfFeedbacks,
        fn {_k, list} -> length(list) != 1 end # PERF optimize performance by not using length method
        # TODO what happens when length(list) == 1 ?
      ) |> Enum.into(%{})

    trimmedUnknownWordsMap =
      Enum.map(
        unknownWordsMap,
        fn {k, largeListOfWords} ->
          {k,
          Enum.filter(
            largeListOfWords,
            fn (word) ->
              thisWordsChars = word |> String.graphemes()
              (lengthOfTotalRemainingLetters - 5) == length(
                remainingLetters -- thisWordsChars
                )
            end)
          }
        end) |> Enum.into(%{})

    Map.merge(knownWordsMap, trimmedUnknownWordsMap)
  end

  def getCompleteListOfCharactersAvailableOnBoard(board) do
    board.characterStrings
    |> List.flatten()
    |> Enum.filter(&(&1 != " "))
  end
end
