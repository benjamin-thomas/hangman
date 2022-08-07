defmodule B1Web.HangmanView do
  use B1Web, :view

  @spec stick_man(0 | 1 | 2 | 3 | 4 | 5 | 6 | 7) :: String.t()
  def stick_man(0) do
    ~S{
      +---+
      |   |
      O   |
     /|\  |
     / \  |
          |
    =========
    }
  end

  def stick_man(1) do
    ~S{
      +---+
      |   |
      O   |
     /|\  |
     /    |

     =========
     }
  end

  def stick_man(2) do
    ~S{
      +---+
      |   |
      O   |
     /|\  |
          |
          |
    =========
    }
  end

  def stick_man(3) do
    ~S{
      +---+
      |   |
      O   |
     /|   |
          |
          |
    =========
    }
  end

  def stick_man(4) do
    ~S{
      +---+
      |   |
      O   |
      |   |
          |
          |
    =========
    }
  end

  def stick_man(5) do
    ~S{
      +---+
      |   |
      O   |
          |
          |
          |
    =========
    }
  end

  def stick_man(6) do
    ~S{
      +---+
      |   |
          |
          |
          |
          |
    =========
    }
  end

  def stick_man(7) do
    ~S{
      +---+
          |
          |
          |
          |
          |
    =========
    }
  end
end
