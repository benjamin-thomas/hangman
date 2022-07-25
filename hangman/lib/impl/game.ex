defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer(),
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
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

  @spec make_move(t(), String.t()) :: {t(), Type.tally()}
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    update(game, guess)
    |> return_with_tally()
  end

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: [],
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp update(game, guess) do
    duplicate_move? = MapSet.member?(game.used, guess)
    good_guess? = Enum.member?(game.letters, guess)
    new_used = MapSet.put(game.used, guess)

    {new_state, new_turns_left} =
      case {duplicate_move?, good_guess?} do
        {true, _} -> {:already_used, game.turns_left}
        {false, true} -> {:good_guess, game.turns_left - 1}
        {false, false} -> {:bad_guess, game.turns_left - 1}
      end

    # {new_state, new_turns_left} =
    #   if(duplicate_move?) do
    #     {:already_used, game.turns_left}
    #   else
    #     if good_guess? do
    #       {:good_guess, game.turns_left - 1}
    #     else
    #       {:bad_guess, game.turns_left - 1}
    #     end
    #   end

    %{game | game_state: new_state, turns_left: new_turns_left, used: new_used}
  end
end
