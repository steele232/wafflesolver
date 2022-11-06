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

    IO.puts("First board:")
    IO.inspect(firstBoard)

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
        fn {_k, list} -> length(list) != 1 end # PERF optimize performance by not using length method
        # TODO what happens when length(list) == 1 ?
      ) |> Enum.into(%{})

    trimmedUnknownWordsMap =
      Enum.map(
        unknownWordsMap,
        fn {wordIdentifier, largeListOfWords} ->
          {wordIdentifier,
          Enum.filter(
            largeListOfWords,
            fn (word) ->
              charsAvailableForThisWord = getCharsAvailableForThisWord(wordIdentifier, knownWordsMap, completeListOfLetters)
              lengthOfCharsAvailableForThisWord = length(charsAvailableForThisWord)
              thisWordsChars = word |> String.graphemes()
              (lengthOfCharsAvailableForThisWord - 5) == length(
                charsAvailableForThisWord -- thisWordsChars
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

  @spec getCharsAvailableForThisWord(:hw1 | :hw2 | :hw3 | :vw1 | :vw2 | :vw3, map, [binary]) :: [binary]
  def getCharsAvailableForThisWord(wordIdentifier, knownWordsMap, completeListOfLetters) do

    # almost called this val: intersectingCharsThatAreKnownAndIDontWantToMarkAsBeingUsedUpDespiteTheirBeingUsedInAKnownWord =
    knownIntersections =
      case wordIdentifier do
        :hw1 ->
          [
          getChar(knownWordsMap, :vw1, 1),
          getChar(knownWordsMap, :vw2, 1),
          getChar(knownWordsMap, :vw3, 1)
          ] |> List.flatten()
        :hw2 ->
          [
          getChar(knownWordsMap, :vw1, 3),
          getChar(knownWordsMap, :vw2, 3),
          getChar(knownWordsMap, :vw3, 3)
          ] |> List.flatten()
        :hw3 ->
          [
          getChar(knownWordsMap, :vw1, 5),
          getChar(knownWordsMap, :vw2, 5),
          getChar(knownWordsMap, :vw3, 5)
          ] |> List.flatten()
        :vw1 ->
          [
          getChar(knownWordsMap, :hw1, 1),
          getChar(knownWordsMap, :hw2, 1),
          getChar(knownWordsMap, :hw3, 1)
          ] |> List.flatten()
        :vw2 ->
          [
          getChar(knownWordsMap, :hw1, 3),
          getChar(knownWordsMap, :hw2, 3),
          getChar(knownWordsMap, :hw3, 3)
          ] |> List.flatten()
        :vw3 ->
          [
          getChar(knownWordsMap, :hw1, 5),
          getChar(knownWordsMap, :hw2, 5),
          getChar(knownWordsMap, :hw3, 5)
          ] |> List.flatten()
      end

    usedUpLetters =
      knownWordsMap
      |> Enum.map(fn {_k, list} -> list end)
      |> List.flatten()
      |> Enum.map(&String.graphemes/1)
      |> List.flatten()
    remainingLetters = completeListOfLetters -- usedUpLetters
    availableLetters = remainingLetters ++ knownIntersections
    availableLetters
  end

  @spec getChar(map, atom, integer) :: [binary]
  def getChar(knownWordMap, wordIdentifier, n) do
    case Map.has_key?(knownWordMap, wordIdentifier) do
      true ->
        %{^wordIdentifier => [word]} = knownWordMap
        chars = word |> String.graphemes()
        [
          :lists.nth(n, chars)
        ]
      false ->
        [] # this will be List.flatten'ed in the usage
    end
  end

end
