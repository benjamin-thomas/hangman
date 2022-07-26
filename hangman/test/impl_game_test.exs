# find ./lib/ ./test -type f | entr -c mix test --cover
defmodule ImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game
  doctest(Game)

  test "new_game() returns a structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.status == :initializing
    assert length(game.letters) > 0
  end

  test "new_game() can receive a starting word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.status == :initializing
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
      game = Map.put(game, :status, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")
    assert game.status != :already_used

    {game, _tally} = Game.make_move(game, "y")
    assert game.status != :already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.status == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "recognize a letter in the word" do
    game = Game.new_game("hello")

    {game, tally} = Game.make_move(game, "h")
    assert tally.turns_left == 7
    assert tally.status == :good_guess
    assert tally.turns_left == 7

    {_game, tally} = Game.make_move(game, "x")
    assert tally.status == :bad_guess
  end

  test "recognize a letter not in the word" do
    game = Game.new_game("hello")

    {game, tally} = Game.make_move(game, "z")
    assert tally.turns_left == 6
    assert tally.status == :bad_guess

    {game, tally} = Game.make_move(game, "h")
    assert tally.turns_left == 6
    assert tally.status == :good_guess

    {_game, tally} = Game.make_move(game, "e")
    assert tally.turns_left == 6
    assert tally.status == :good_guess
  end

  test "can handle a sequence of moves" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
    ]
    |> test_sequence("hello")
  end

  test "winning game" do
    [
      ["h", :good_guess, 7, ["h", "_", "_", "_", "_"], ["h"]],
      ["e", :good_guess, 7, ["h", "e", "_", "_", "_"], ["e", "h"]],
      ["l", :good_guess, 7, ["h", "e", "l", "l", "_"], ["e", "h", "l"]],
      ["o", :won, 7, ["h", "e", "l", "l", "o"], ["e", "h", "l", "o"]]
    ]
    |> test_sequence("hello")
  end

  test "loosing game" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess, 4, ["_", "_", "_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess, 3, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d"]],
      ["f", :bad_guess, 2, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d", "f"]],
      ["g", :bad_guess, 1, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d", "f", "g"]],
      ["i", :lost, 0, ["h", "e", "l", "l", "o"], ["a", "b", "c", "d", "f", "g", "i"]]
    ]
    |> test_sequence("hello")
  end

  def test_sequence(script, word) do
    game = Game.new_game(word)
    Enum.reduce(script, game, &check_move/2)
  end

  defp check_move([guess, status, turns_left, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.status == status
    assert tally.turns_left == turns_left
    assert tally.letters == letters
    assert tally.used == used
    game
  end
end
