defmodule Demo.Wordle.Feedback do
  alias Demo.Wordle.Feedback

  defstruct [guess: "",
            feedback: "",
            blackList: [],
            neededList: [],
            knownList: %{},
            positionalBlackList: []]

  @spec fromStrings(binary, binary) :: %Feedback{}
  def fromStrings(word, feedbackString) do
    # assert strings are valid lengths
    5 = String.length(word)
    5 = String.length(feedbackString)

    wordAsList = String.graphemes(word)
    feedbackAsList = String.graphemes(feedbackString)

    pairs =
      Enum.zip(
        wordAsList,
        feedbackAsList
      )

    blackList =
      pairs
      |> Enum.filter(fn {_, f} -> f == "0" end)
      |> Enum.map(fn {ch, _} -> ch end)

    neededList =
      pairs
      |> Enum.filter(fn {_, f} -> f == "1" end)
      |> Enum.map(fn {ch, _} -> ch end)

    augmentedPairs =
      pairs
      |> Enum.zip_with(
        [1,2,3,4,5],
        fn ({a,b},c) ->
          {a,b,c}
        end
      )
    knownList =
      augmentedPairs
      |> Enum.filter(fn {_, f, _} -> f == "2" end)
      |> Enum.reduce(
        %{},
        fn ({character, _feedbackNumStr, position}, accum) ->
          Map.put(accum, position, character)
        end
      )
    positionalBlackList =
      augmentedPairs
      |> Enum.filter(fn {_, f, _} -> f == "0" or f == "1" or f == "4" end)
      |> Enum.reduce(
        [],
        fn ({character, _feedbackNumStr, position}, accum) ->
          [{position, character} | accum]
        end
      )

    %Feedback{
      guess: word,
      feedback: feedbackString,
      blackList: blackList,
      neededList: neededList,
      knownList: knownList,
      positionalBlackList: positionalBlackList
    }
  end
end
