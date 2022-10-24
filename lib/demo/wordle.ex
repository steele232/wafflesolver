defmodule Demo.Wordle do
  alias Demo.Wordle.Feedback

  @alphabet "abcdefghijklmnopqrstuvwxyz"

  @spec solve(list(Feedback)) :: list(String.t())
  def solve(listOfFeedbacks) do
    aggFeedback = aggregateFeedback(listOfFeedbacks)
    regexString = createRegexStringFromAggregatedFeedback(aggFeedback)
    allWords = grabAllWordsFromConfig()
    filterByFeedbackAndRegex(allWords, aggFeedback, regexString)
  end

  defp filterByFeedbackAndRegex(wordList, aggFeedback, regexString) do
    wordList
    |> Enum.filter(&filterByRegex(&1, regexString))
    |> Enum.filter(&filterByMultipleNeededChars(&1, aggFeedback.neededList))
    |> Enum.filter(&filterByKnownChars(&1, aggFeedback.knownList))
    |> Enum.filter(&filterByPositionalBlacklist(&1, aggFeedback.positionalBlackList))
  end

  defp aggregateFeedback(listOfFeedbacks) do
    # TODO
    %Feedback{}
  end

  defp mergeFeedbacks(left, right) do
    # TODO
    %Feedback{}
  end

  defp filterByRegex(word, regex) do
  end

  defp filterByMultipleNeededChars(word, listOfNeededChars) do
  end

  defp filterByKnownChars(word, knownWordMap) do
  end

  defp filterByPositionalBlacklist(word, positionalBlackListMap) do
  end

  defp createRegexStringFromAggregatedFeedback(aggregatedFeedback) do

    reverseAlphabetList = String.graphemes(@alphabet) |> :lists.reverse()

    Enum.map(1..5, fn idx ->
      case Map.has_key?(aggregatedFeedback.knownList, idx) do
        true ->
          Map.get(aggregatedFeedback.knownList, idx)

        false ->
          to_string(
            ["["] ++
              Enum.filter(reverseAlphabetList, fn alphChar ->
                # NOT in positionalBlacklist
                (not Map.has_key?(aggregatedFeedback.positionalBlackList, alphChar)) and
                # and NOT in blacklist
                (not Enum.member?(aggregatedFeedback.blackList, alphChar))
              end) ++
              ["]"]
          )
      end
    end)
    |> to_string
  end

  @spec grabAllWordsFromConfig :: [String.t()]
  def grabAllWordsFromConfig() do
    {:ok, body} =
      :code.priv_dir(:demo)
      |> Path.join("demo/data/words.txt")
      |> File.read()

    body
    |> String.split(" ")
  end
end
