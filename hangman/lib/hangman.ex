defmodule Hangman do
  alias Hangman.Impl
  @opaque game :: Impl.Game.t()
  @type tally :: Type.tally()

  @spec new_game :: game
  defdelegate new_game, to: Impl.Game

  @spec make_move(game, String.t()) :: {game, Type.tally()}
  defdelegate make_move(game, guess), to: Impl.Game

  @spec tally(game) :: %{
          letters: list(String.t()),
          status: Type.status(),
          turns_left: integer(),
          used: list(String.t())
        }
  defdelegate tally(game), to: Impl.Game
end
