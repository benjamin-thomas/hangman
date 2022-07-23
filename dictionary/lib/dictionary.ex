defmodule Dictionary do
  @world_list "./assets/words.txt"
              |> File.read!()
              |> String.split("\n", trim: true)

  @spec random_word :: String.t()
  def random_word do
    @world_list
    |> Enum.random()
  end
end
