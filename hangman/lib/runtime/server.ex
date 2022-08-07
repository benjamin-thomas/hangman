defmodule Hangman.Runtime.Server do
  @type t :: pid

  alias Hangman.Impl.Game
  use GenServer

  ### client processes

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ### server processes

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {updated_ame, tally} = Game.make_move(game, guess)
    {:reply, tally, updated_ame}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end
end
