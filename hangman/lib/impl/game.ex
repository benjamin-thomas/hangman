defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer(),
          status: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct(
    turns_left: 7,
    status: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game(String.t()) :: t()
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  @spec new_game :: t()
  def new_game do
    new_game(Dictionary.random_word())
  end

  def make_move(game, guess) do
    update(game, guess)
    |> return_with_tally()
  end

  defp tally(game) do
    maybe_reveal = fn letter ->
      if MapSet.member?(game.used, letter) do
        letter
      else
        "_"
      end
    end

    %{
      turns_left: game.turns_left,
      status: game.status,
      letters: Enum.map(game.letters, maybe_reveal),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp update(game, guess) do
    game_over? = game.status in [:won, :lost]
    duplicate_move? = MapSet.member?(game.used, guess)
    good_guess? = Enum.member?(game.letters, guess)

    {status, turns_left} =
      cond do
        game_over? -> {game.status, game.turns_left}
        duplicate_move? -> {:already_used, game.turns_left}
        good_guess? -> {:good_guess, game.turns_left}
        not good_guess? -> {:bad_guess, game.turns_left - 1}
      end

    used =
      if game_over? do
        game.used
      else
        MapSet.put(game.used, guess)
      end

    %{game | status: status, turns_left: turns_left, used: used}
  end
end
