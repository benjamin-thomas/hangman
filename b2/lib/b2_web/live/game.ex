defmodule B2Web.Live.Game do
  use B2Web, :live_view

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket = assign(socket, %{game: game, tally: tally})

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="game-holder">
      <%= live_component(__MODULE__.StickMan,@tally, id: 1) %>
      <%= live_component(__MODULE__.Alphabet,@tally, id: 2) %>
      <%= live_component(__MODULE__.WordSoFar,@tally, id: 3) %>
      <%= inspect @tally %>
    </div>
    """
  end
end
