defmodule Solution do
  @spec count_good_rectangles(rectangles :: [[integer]]) :: integer
  def count_good_rectangles(rectangles) do
    {_max_len, count} =
      Enum.reduce(rectangles, {0, 0}, fn [a, b], {max_len, count} ->
        side = min(a, b)

        cond do
          side > max_len -> {side, 1}
          side == max_len -> {max_len, count + 1}
          true -> {max_len, count}
        end
      end)

    count
  end
end
