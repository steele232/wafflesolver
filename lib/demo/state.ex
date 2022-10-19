defmodule Demo.State do
  alias Demo.State

  defstruct iteration: 0, letters: Enum.map(1..25, fn _ -> nil end)

end
