defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact({game, tally})
    :ok
  end

  @spec interact(state) :: :ok
  def interact({_game, _tally = %{status: :won}}) do
    IO.puts("Congratulations. You won!")
  end

  def interact({_game, tally = %{status: :lost}}) do
    IO.puts("Sorry, ou lost... The word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    tally = Hangman.make_move(game, get_guess())
    interact({game, tally})
  end

  def feedback_for(tally = %{status: :initializing}) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(_tally = %{status: :good_guess}), do: "Good guess!"
  def feedback_for(_tally = %{status: :bad_guess}), do: "Bad guess!"
  def feedback_for(_tally = %{status: :already_used}), do: "You already used that letter!"

  @spec current_word(tally()) :: [String.t(), ...]
  def current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      "   turns_left: ",
      IO.ANSI.light_blue(),
      tally.turns_left |> to_string(),
      IO.ANSI.reset(),
      "   used so far: ",
      IO.ANSI.yellow(),
      tally.used |> Enum.join(","),
      IO.ANSI.reset()
    ]
  end

  @spec get_guess :: String.t()
  def get_guess() do
    IO.gets("Enter a letter to guess: ")
    |> String.trim()
    |> String.downcase()
  end
end
