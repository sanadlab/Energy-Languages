defmodule Solution do
  @spec judge_circle(moves :: String.t) :: boolean
  def judge_circle(moves) do
    {x, y} =
      moves
      |> String.to_charlist()
      |> Enum.reduce({0, 0}, fn
        ?U, {x, y} -> {x, y + 1}
        ?D, {x, y} -> {x, y - 1}
        ?R, {x, y} -> {x + 1, y}
        ?L, {x, y} -> {x - 1, y}
        _, acc -> acc
      end)

    x == 0 and y == 0
  end
end
