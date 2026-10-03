defmodule Solution do
  @spec max_total_fruits(fruits :: [[integer]], start_pos :: integer, k :: integer) :: integer
  def max_total_fruits(fruits, start_pos, k) do
    tup = fruits |> Enum.map(fn [p, a] -> {p, a} end) |> List.to_tuple()
    n = tuple_size(tup)

    if n == 0 do
      0
    else
      {_i, _total, best} =
        Enum.reduce(0..(n - 1), {0, 0, 0}, fn j, {i, total, best} ->
          {_pj, aj} = elem(tup, j)
          total = total + aj
          {i, total} = shrink(tup, start_pos, k, i, j, total)
          best = if i <= j and total > best, do: total, else: best
          {i, total, best}
        end)

      best
    end
  end

  defp shrink(tup, sp, k, i, j, total) do
    if i <= j do
      {pi, ai} = elem(tup, i)
      {pj, _} = elem(tup, j)

      if cost(pi, pj, sp) > k do
        shrink(tup, sp, k, i + 1, j, total - ai)
      else
        {i, total}
      end
    else
      {i, total}
    end
  end

  defp cost(pos_l, pos_r, start_pos) do
    cond do
      pos_r <= start_pos -> start_pos - pos_l
      pos_l >= start_pos -> pos_r - start_pos
      true -> pos_r - pos_l + min(start_pos - pos_l, pos_r - start_pos)
    end
  end
end
