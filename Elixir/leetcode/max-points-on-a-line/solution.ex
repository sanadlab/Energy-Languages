defmodule Solution do
  @spec max_points(points :: [[integer]]) :: integer
  def max_points(points) do
    n = length(points)

    if n <= 2 do
      n
    else
      pts = points |> Enum.map(fn [x, y] -> {x, y} end) |> List.to_tuple()
      outer(pts, n, 0, 1)
    end
  end

  defp outer(_pts, n, i, best) when i >= n, do: best
  defp outer(pts, n, i, best) do
    {xi, yi} = elem(pts, i)
    best = inner(pts, n, i + 1, %{}, best, xi, yi)
    outer(pts, n, i + 1, best)
  end

  defp inner(_pts, n, j, _slopes, best, _xi, _yi) when j >= n, do: best
  defp inner(pts, n, j, slopes, best, xi, yi) do
    {xj, yj} = elem(pts, j)
    dx = xj - xi
    dy = yj - yi
    g = Integer.gcd(abs(dx), abs(dy))
    dx = div(dx, g)
    dy = div(dy, g)
    {dx, dy} = if dx < 0 or (dx == 0 and dy < 0), do: {-dx, -dy}, else: {dx, dy}
    key = {dx, dy}
    cnt = Map.get(slopes, key, 0) + 1
    slopes = Map.put(slopes, key, cnt)
    best = if cnt + 1 > best, do: cnt + 1, else: best
    inner(pts, n, j + 1, slopes, best, xi, yi)
  end
end
