defmodule B2Web.Live.Game.Alphabet do
  use B2Web, :live_component

  def mount(socket) do
    letters = ?a..?z |> Enum.map(fn ch -> <<ch::utf8>> end)
    {:ok, socket |> assign(:letters, letters)}
  end

  def render(assigns) do
    ~H"""
    <div class="alphabet">
      <%= for letter <- @letters do %>
        <div
        phx-click="make_move"
        phx-value-key={letter}
        class={class_for(letter, @tally)}>
          <%= letter %>
        </div>
      <% end %>
    </div>
    """
  end

  defp class_for(letter, tally) do
    tail =
      cond do
        Enum.member?(tally.letters, letter) -> "correct"
        Enum.member?(tally.used, letter) -> "wrong"
        true -> "not-used-yet"
      end

    "one-letter" <> " " <> tail
  end
end
