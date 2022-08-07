defmodule B1Web.HangmanController do
  use B1Web, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    conn
    |> put_session(:game, game)
    |> render("game.html", tally: tally)
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]

    tally =
      get_session(conn, :game)
      |> Hangman.make_move(guess)

    put_in(conn.params["make_move"]["guess"], "")
    |> render("game.html", tally: tally)
  end
end
