defmodule Solution do
  @spec min_area_rect(points :: [[integer]]) :: integer
  def min_area_rect(points) do
    seen = MapSet.new(Enum.map(points, fn [x, y] -> x * 50000 + y end))
    pts = points |> Enum.map(fn [x, y] -> {x, y} end) |> List.to_tuple()
    n = tuple_size(pts)

    best =
      for i <- 0..(n - 1)//1, j <- (i + 1)..(n - 1)//1, reduce: :inf do
        acc ->
          {x1, y1} = elem(pts, i)
          {x2, y2} = elem(pts, j)

          if x1 != x2 and y1 != y2 and
               MapSet.member?(seen, x1 * 50000 + y2) and
               MapSet.member?(seen, x2 * 50000 + y1) do
            area = abs(x1 - x2) * abs(y1 - y2)
            if acc == :inf or area < acc, do: area, else: acc
          else
            acc
          end
      end

    if best == :inf, do: 0, else: best
  end
end
