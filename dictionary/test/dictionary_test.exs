defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "returns a random word" do
    word_length = Dictionary.random_word() |> String.length()
    assert word_length > 0
  end
end
