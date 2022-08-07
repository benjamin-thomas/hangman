defmodule B1Web.HangmanView do
  use B1Web, :view

  # https://blog.kalvad.com/dry-your-phoenix-templates/ph

  @spec status(Hangman.Type.status()) :: {:safe, any()}
  def status(:initializing), do: content_tag(:p, "")
  def status(:won), do: content_tag(:p, "WON", class: "won")
  def status(:lost), do: content_tag(:p, "LOST", class: "lost")
  def status(:good_guess), do: content_tag(:p, "GOOD_GUESS", class: "good-guess")
  def status(:bad_guess), do: content_tag(:p, "BAD_GUESS", class: "bad-guess")
  def status(:already_used), do: content_tag(:p, "ALREADY_USED", class: "already-used")

  @spec next_move_or_restart(Plug.Conn.t(), Hangman.Type.status()) :: {:safe, String.t()}
  def next_move_or_restart(conn, status) when status in [:won, :lost] do
    # link("Start a new game", to: Routes.hangman_path(conn, :new), class: "button")
    button("Start a new game", to: Routes.hangman_path(conn, :create))
  end

  def next_move_or_restart(conn, _status) do
    update_path = Routes.hangman_path(conn, :update)
    form_config = [as: "make_move", autocomplete: "off", method: :put]

    form_for(
      conn,
      update_path,
      form_config,
      fn f ->
        [
          label(f, :guess),
          text_input(f, :guess, autofocus: true),
          submit("Make next guess")
        ]
      end
    )
  end

  @spec stick_man(0 | 1 | 2 | 3 | 4 | 5 | 6 | 7) :: String.t()
  defdelegate stick_man(turns_left), to: B1Web.Hangman.StickMan
end
