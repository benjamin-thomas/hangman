defmodule Hangman do
  alias Hangman.Impl
  @opaque game :: Impl.Game.t()

  @spec new_game :: game
  defdelegate new_game, to: Impl.Game

  @spec make_move(game, String.t()) :: {game, Type.tally()}
  defdelegate make_move(game, guess), to: Impl.Game
end
