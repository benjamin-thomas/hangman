defmodule Hangman do
  alias Hangman.Impl
  @opaque game :: Impl.Game.t()
  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @type tally :: %{
          turns_left: integer,
          game_state: State.state(),
          letters: list(String.t()),
          used: list(String.t())
        }

  @spec new_game :: game
  defdelegate new_game, to: Impl.Game

  @spec make_move(game, String.t()) :: {game, tally}
  def make_move(_game, _guess) do
  end
end
