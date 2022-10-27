defmodule Demo.Waffle do
  alias Demo.Waffle.Board
  alias Demo.Wordle.Feedback
  alias Demo.Wordle

  def solve(listOfBoards) do
    # TODO first attempt to solve all the words
    # TODO print it out to see how we are doing...
    # TODO find the most solved word.. and then go from there

    # TODO grab data necessary to run Wordle.solve/1
    #   get list of feedbacks based on [{guess, feedback}]
    #   for each word
    #

    firstBoard = listOfBoards |> List.first()

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

    listOfSolvedWords = [
      hw1F,
      hw2F,
      hw3F,
      vw1F,
      vw2F,
      vw3F
    ]

    sortedList =
      listOfSolvedWords
      |> Enum.sort(fn left, right -> length(left) <= length(right) end)
      |> IO.inspect()


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

    trimLongListsBasedOnKnownWords(
      getCompleteListOfCharactersAvailableOnBoard(firstBoard),
      listOfSolvedWords
    )
  end

  def trimLongListsBasedOnKnownWords(completeListOfLetters, listOfCandidateLists) do
    # TODO find the list of known words
    # TODO find the remaining letters
    # TODO iterate through candidate lists and
    # .  remove words if they are not achievable based on available letters
    knownWords =
      Enum.filter(
        listOfCandidateLists,
        fn list -> length(list) == 1 end # TODO optimize performance by not using length method
      )

    usedUpLetters = List.flatten(knownWords)
    remainingLetters = completeListOfLetters -- usedUpLetters
    lengthOfTotalRemainingLetters = length(remainingLetters)

    unknownWords =
      Enum.filter(
        listOfCandidateLists,
        fn list -> length(list) != 1 end # TODO optimize performance by not using length method
      )

    trimmedUnknownWords =
      Enum.map(
        unknownWords,
        fn largeListOfWords ->
          Enum.filter(
            largeListOfWords,
            fn (word) ->
              thisWordsChars = word |> String.graphemes()
              (lengthOfTotalRemainingLetters - 5) == length(
                remainingLetters -- thisWordsChars
                )
            end)
        end)

    knownWords ++ trimmedUnknownWords
  end

  def getCompleteListOfCharactersAvailableOnBoard(board) do
    board.characterStrings
    |> List.flatten()
    |> Enum.filter(&(&1 != " "))
  end
end
