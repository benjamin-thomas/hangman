defmodule B2Web.Live.Game.StickMan do
  use B2Web, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <p>
      Stick man...
    </p>
    """
  end
end
