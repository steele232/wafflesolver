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
    Enum.reduce(
      listOfFeedbacks,
      %Feedback{},
      &mergeFeedbacks/2
    )
  end

  def mergeFeedbacks(left, right) do
    mergedBlackList = (left.blackList ++ right.blackList) |> Enum.uniq()
    mergedNeededList = (left.neededList ++ right.neededList) |> Enum.uniq()
    mergedKnownList = Map.merge(left.knownList, right.knownList)

    mergedPositionalBlackList =
      (left.positionalBlackList ++ right.positionalBlackList) |> Enum.uniq()

    %Feedback{
      guess: "",
      feedback: "",
      blackList: mergedBlackList,
      neededList: mergedNeededList,
      knownList: mergedKnownList,
      positionalBlackList: mergedPositionalBlackList
    }
  end

  def filterByRegex(word, regexString) do
    Regex.compile!(regexString)
    |> Regex.match?(word)
  end

  def filterByMultipleNeededChars(word, listOfNeededChars) do
    Enum.all?(
      listOfNeededChars,
      fn ch -> String.contains?(word, ch) end
    )
  end

  def filterByKnownChars(word, knownWordMap) do
    Enum.all?(
      knownWordMap,
      fn {position, knownCharacter} ->
        foundChar = :lists.nth(position, String.graphemes(word))
        foundChar == knownCharacter
      end
    )
  end

  defp filterByPositionalBlacklist(word, positionalBlackList) do
    Enum.all?(
      positionalBlackList,
      fn {position, characterToAvoid} ->
        foundChar = :lists.nth(position, String.graphemes(word))
        foundChar != characterToAvoid
      end
    )
  end

  def createRegexStringFromAggregatedFeedback(aggregatedFeedback) do
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
                # and NOT in blacklist
                not Enum.any?(
                  aggregatedFeedback.positionalBlackList,
                  fn {position, characterToAvoid} ->
                    position == idx and characterToAvoid == alphChar
                  end
                ) and
                  not Enum.member?(aggregatedFeedback.blackList, alphChar)
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
