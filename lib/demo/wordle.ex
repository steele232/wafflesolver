defmodule Demo.Wordle do
  alias Demo.Wordle.Feedback

  @alphabet "abcdefghijklmnopqrstuvwxyz"

  @spec solve(list(Feedback)) :: list(String.t())
  def solve(listOfFeedbacks) do
    aggFeedback = aggregateFeedback(listOfFeedbacks)
    regexString =  createRegexStringFromAggregatedFeedback(aggFeedback)
    allWords = grabAllWordsFromConfig()
    filterByFeedbackAndRegex(allWords, aggFeedback, regexString)
  end

  defp filterByFeedbackAndRegex(wordList, aggFeedback, regexString) do
    wordList
    |> Enum.filter( &( filterByRegex(&1, regexString)))
    |> Enum.filter( &( filterByMultipleNeededChars(&1, aggFeedback.neededList)) )
    |> Enum.filter( &( filterByKnownChars(&1, aggFeedback.knownList)))
    |> Enum.filter( &( filterByPositionalBlacklist(&1, aggFeedback.positionalBlackList)))
  end

  defp aggregateFeedback(listOfFeedbacks) do
    %Feedback{} # TODO
  end

  defp mergeFeedbacks(left, right) do
    %Feedback{} # TODO
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

  end

  @spec grabAllWordsFromConfig :: [String.t()]
  def grabAllWordsFromConfig() do
    {:ok, body} = :code.priv_dir(:demo)
    |> Path.join("demo/data/words.txt")
    |> File.read
    body
    |> String.split(" ")
  end

end
