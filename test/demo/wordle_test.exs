defmodule WordleTest do
  use ExUnit.Case, async: true
  alias Demo.Wordle.Feedback
  alias Demo.Wordle

  test "grab words from config" do
    wordsString = Wordle.grabAllWordsFromConfig()
    IO.inspect(:lists.sublist(wordsString, 50))

    assert 50 < length(wordsString)
  end


  test "collect feedback from strings" do
    f = Feedback.fromStrings("aegis", "12302")
    assert f.guess == "aegis"
    assert f.feedback == "12302"
    assert f.blackList == ["i"]
    assert f.neededList == ["a"] # TODO should I also put 2s in there?
    assert f.knownList == %{2 => "e", 5 => "s"} # NOTE I'm using 1-based index for this.. because :lists.nth does that...
    assert f.positionalBlackList == %{4 => "i"}
  end


end
