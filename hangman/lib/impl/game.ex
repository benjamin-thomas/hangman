defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer(),
          status: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct(
    turns_left: 7,
    status: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game(String.t()) :: t()
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  @spec new_game :: t()
  def new_game do
    new_game(Dictionary.random_word())
  end

  def make_move(game, guess) do
    update(game, guess)
    |> return_with_tally()
  end

  @spec tally(t) :: %{
          letters: list(String.t()),
          status: Type.status(),
          turns_left: integer(),
          used: list(String.t())
        }
  def tally(game) do
    maybe_reveal = fn letter ->
      if MapSet.member?(game.used, letter) or game.status == :lost do
        letter
      else
        "_"
      end
    end

    %{
      turns_left: game.turns_left,
      status: game.status,
      letters: Enum.map(game.letters, maybe_reveal),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  @spec validate_input(String.t()) :: {:err, nil} | {:ok, String.t()}
  @doc """
  Ensures the guess is a single lower ascii alpha character.

  ## Examples

    iex> Hangman.Impl.Game.validate_input("a")
    {:ok, "a"}

    iex> Hangman.Impl.Game.validate_input("ab")
    {:err, nil}

    iex> Hangman.Impl.Game.validate_input("+")
    {:err, nil}
  """
  def validate_input(guess) do
    if String.length(guess) == 1 and guess =~ ~r/[a-z]/ do
      {:ok, guess}
    else
      {:err, nil}
    end
  end

  defp update(game, guess) do
    {:ok, guess} = validate_input(guess)

    game_over? = game.status in [:won, :lost]

    used =
      if game_over? do
        game.used
      else
        MapSet.put(game.used, guess)
      end

    duplicate_move? = MapSet.member?(game.used, guess)
    good_guess? = Enum.member?(game.letters, guess)
    won? = Enum.all?(game.letters, fn letter -> MapSet.member?(used, letter) end)
    lost? = game.turns_left == 1 and not good_guess?

    {status, turns_left} =
      cond do
        game_over? -> {game.status, game.turns_left}
        won? -> {:won, game.turns_left}
        lost? -> {:lost, game.turns_left - 1}
        duplicate_move? -> {:already_used, game.turns_left}
        good_guess? -> {:good_guess, game.turns_left}
        not good_guess? -> {:bad_guess, game.turns_left - 1}
      end

    %{game | status: status, turns_left: turns_left, used: used}
  end
end
