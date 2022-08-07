defmodule TextClient.Runtime.RemoteHangman do
  @remote_server :hangman@X230
  @spec connect :: pid
  def connect() do
    :rpc.call(@remote_server, Hangman, :new_game, [])
  end
end
