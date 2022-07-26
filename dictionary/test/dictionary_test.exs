defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "returns a random word" do
    words = Dictionary.start()
    word_length = Dictionary.random_word(words) |> String.length()
    assert word_length > 0
  end
end
