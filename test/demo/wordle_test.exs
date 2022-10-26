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
    assert f.positionalBlackList == [{4, "i"}, {1, "a"}]
  end

  test "exact match feedback" do
    f = Feedback.fromStrings("aegis", "22222")
    assert f.guess == "aegis"
    assert f.feedback == "22222"
    assert f.blackList == []
    assert f.neededList == [] # TODO should I also put 2s in there?
    assert f.knownList == %{
      1 => "a",
      2 => "e",
      3 => "g",
      4 => "i",
      5 => "s"
    } # NOTE I'm using 1-based index for this.. because :lists.nth does that...
    assert f.positionalBlackList == []
  end

  test "solve based on exact match" do
    f = Feedback.fromStrings("aegis", "22222")
    assert f.guess == "aegis"
    assert f.feedback == "22222"
    assert f.blackList == []
    assert f.neededList == [] # TODO should I also put 2s in there?
    assert f.knownList == %{
      1 => "a",
      2 => "e",
      3 => "g",
      4 => "i",
      5 => "s"
    } # NOTE I'm using 1-based index for this.. because :lists.nth does that...
    assert f.positionalBlackList == []

    assert ["aegis"] == Wordle.solve([f])
  end

  test "solve based on 1 yellow" do
    expectedWords = ["bacon", "badly", "balky", "balmy", "banal", "bandy", "banjo", "baron", "batch", "baton", "batty", "bawdy", "bayou", "black", "bland", "blank", "bloat", "board", "borax", "bract", "brand", "bravo", "brawl", "brawn", "broad", "burma", "bylaw", "byway", "cabal", "cabby", "cacao", "caddy", "calyx", "canal", "candy", "canny", "canon", "canto", "capon", "carat", "carob", "carol", "carom", "carry", "catch", "catty", "caulk", "chaff", "chalk", "champ", "chant", "chary", "chard", "charm", "chart", "clack", "clamp", "clank", "cloak", "coach", "cobra", "cocoa", "comma", "copal", "copra", "coral", "crack", "craft", "cramp", "crank", "crawl", "crazy", "croak", "croat", "cuban", "daddy", "daffy", "dally", "dandy", "datum", "daunt", "draft", "drama", "drank", "drawl", "drawn", "dryad", "ducal", "ducat", "dwarf", "facto", "fancy", "fanny", "farad", "fatal", "fatty", "fault", "fauna", "favor", "flack", "flaky", "flank", "float", "flora", "foamy", "focal", "foray", "forma", "franc", "frank", "fraud", "handy", "happy", "hardy", "harpy", "harry", "hatch", "haunt", "havoc", "hoary", "hoard", "human", "hyrax", "jabot", "japan", "jaunt", "jazzy", "junta", "kapok", "kappa", "kaput", "karat", "karma", "kayak", "kazoo", "knack", "koala", "koran", "kraal", "labor", "lanky", "lanka", "larch", "larva", "latch", "llama", "llano", "loamy", "loath", "lobar", "local", "loran", "loyal", "lunar", "macao", "macaw", "macho", "macro", "madam", "madly", "major", "malay", "malta", "mamba", "mambo", "mammy", "manly", "manna", "manor", "manta", "march", "marry", "match", "matzo", "mayan", "mayor", "mocha", "modal", "molar", "monad", "moral", "moray", "mural", "nabob", "nanny", "natal", "natty", "naval", "nodal", "nomad", "noway", "oakum", "octal", "offal", "omaha", "ovary", "paddy", "palmy", "panda", "papal", "papaw", "parch", "parka", "parry", "party", "patch", "patty", "pavan", "phyla", "plank", "plant", "platy", "playa", "plaza", "poach", "polar", "polka", "prank", "prawn", "pupal", "quack", "quaff", "quaky", "qualm", "quark", "quart", "quota", "radar", "radon", "rajah", "rally", "ranch", "ratty", "rayon", "razor", "roach", "roman", "rowan", "royal", "rumba", "rural", "tabby", "taboo", "tabor", "tacky", "taffy", "talky", "tally", "talon", "tampa", "tardy", "tarot", "tarry", "tatty", "taunt", "tawny", "thank", "toady", "today", "tokay", "tonal", "topaz", "torah", "total", "track", "tract", "tramp", "trawl", "ulnar", "ultra", "umbra", "unbar", "uncap", "unman", "urban", "uvula", "valor", "vapor", "vault", "vaunt", "vocal", "vodka", "vulva", "wacky", "waltz", "watch", "whack", "wharf", "woman", "wrack", "wrath", "yacht", "yahoo", "yucca", "zonal"]
    f = Feedback.fromStrings("aegis", "10000")
    assert expectedWords == Wordle.solve([f])
  end

  test "solve based on round 2" do
    expectedWords = ["daunt", "fault", "haunt", "jaunt", "kaput", "taunt", "vault", "vaunt"]
    f1 = Feedback.fromStrings("aegis", "10000")
    f2 = Feedback.fromStrings("quart", "01102")
    assert expectedWords == Wordle.solve([f1, f2])
  end

  test "solve based on round 3" do
    expectedWords = ["fault", "vault"]
    f1 = Feedback.fromStrings("aegis", "10000")
    f2 = Feedback.fromStrings("quart", "01102")
    f3 = Feedback.fromStrings("jaunt", "02202")
    assert expectedWords == Wordle.solve([f1, f2, f3])
  end

  test "solve based on round 4" do
    expectedWords = ["fault"]
    f1 = Feedback.fromStrings("aegis", "10000")
    f2 = Feedback.fromStrings("quart", "01102")
    f3 = Feedback.fromStrings("jaunt", "02202")
    f4 = Feedback.fromStrings("vault", "02222")
    assert expectedWords == Wordle.solve([f1, f2, f3, f4])
  end

  # test "regex .." do
    # f1 = Feedback.fromStrings("aegis", "10000")
    # f2 = Feedback.fromStrings("quart", "01102")
    # f3 = Feedback.fromStrings("jaunt", "02202")
    # f4 = Feedback.fromStrings("vault", "02222")
    # Wordle.createRegexStringFromAggregatedFeedback(



    # )

  # end

  test "merge feedbacks with set-like properties" do
    expectedFeedback = %Feedback{
      guess: "",
      feedback: "",
      blackList: ["e", "g", "i", "s", "q", "r"],
      neededList: ["a", "u"],
      knownList: %{5 => "t"},
      positionalBlackList: [{5, "s"}, {4, "i"}, {3, "g"}, {2, "e"}, {1, "a"}, {4, "r"}, {3, "a"}, {2, "u"}, {1, "q"}]
    }
    f1 = Feedback.fromStrings("aegis", "10000")
    IO.inspect(f1)
    f2 = Feedback.fromStrings("quart", "01102")
    IO.inspect(f2)
    f3 = Wordle.mergeFeedbacks(f1, f2)
    assert f1 != f3
    assert f3 == expectedFeedback
  end


end
