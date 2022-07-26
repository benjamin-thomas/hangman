defmodule Hangman.Type do
  @type status :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @type tally :: %{
          turns_left: integer,
          status: status(),
          letters: list(String.t()),
          used: list(String.t())
        }
end
