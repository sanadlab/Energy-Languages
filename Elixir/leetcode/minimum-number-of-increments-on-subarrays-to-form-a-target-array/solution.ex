defmodule Solution do
  @spec min_number_operations(target :: [integer]) :: integer
  def min_number_operations(target) do
    case target do
      [] ->
        0

      [first | rest] ->
        {ans, _prev} =
          Enum.reduce(rest, {first, first}, fn x, {ans, prev} ->
            if x > prev, do: {ans + (x - prev), x}, else: {ans, x}
          end)

        ans
    end
  end
end
