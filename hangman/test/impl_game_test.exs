defmodule ImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new_game() returns a structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new_game() can receive a starting word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "all letters of random word are lower alpha" do
    game = Game.new_game()
    lower_alpha? = &(&1 =~ ~r/[a-z]/)

    assert game.letters
           |> Enum.all?(lower_alpha?),
           "Oops, failed with: #{game.letters}"
  end

  test "state doesn't change if game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end
end
