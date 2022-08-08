defmodule B2Web.Live.Game.WordSoFar do
  use B2Web, :live_component

  @statuses %{
    initializing: "Type or click on your first guess",
    already_used: "You already picked that letter",
    bad_guess: "That's not in the word",
    good_guess: "Good guess!",
    won: "You won!",
    lost: "You lost :("
  }

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="word-so-far">
      <div class="status">
        <%= status_name @tally.status %>
      </div>
    </div>
    """
  end

  @spec status_name(Hangman.Type.status()) :: String.t()
  defp status_name(status) do
    @statuses[status] || "Unknown status: #{inspect(status)}"
  end
end
