defmodule Solution do
  @spec check_straight_line(coordinates :: [[integer]]) :: boolean
  def check_straight_line(coordinates) do
    [[x0, y0], [x1, y1] | rest] = coordinates
    dx = x1 - x0
    dy = y1 - y0

    Enum.all?(rest, fn [xi, yi] ->
      dx * (yi - y0) == dy * (xi - x0)
    end)
  end
end
