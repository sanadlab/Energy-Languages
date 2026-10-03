defmodule Solution do
  @spec min_cost(max_time :: integer, edges :: [[integer]], passing_fees :: [integer]) :: integer
  def min_cost(max_time, edges, passing_fees) do
    n = length(passing_fees)
    inf = 536_870_912
    fees = List.to_tuple(passing_fees)

    adj_map =
      Enum.reduce(edges, %{}, fn e, acc ->
        case e do
          [x, y, w | _] ->
            if x < 0 or x >= n or y < 0 or y >= n or w < 0 do
              acc
            else
              acc
              |> Map.update(x, [{y, w}], &[{y, w} | &1])
              |> Map.update(y, [{x, w}], &[{x, w} | &1])
            end

          _ ->
            acc
        end
      end)

    adj = for u <- 0..(n - 1), do: Map.get(adj_map, u, [])
    adj = List.to_tuple(adj)

    # dp_rows: t -> (map node -> best fee). Only finite states are stored.
    dp_rows = %{0 => %{0 => elem(fees, 0)}}

    {_rows, ans} =
      Enum.reduce(0..max_time, {dp_rows, inf}, fn t, {rows, ans} ->
        row = Map.get(rows, t, %{})

        Enum.reduce(row, {rows, ans}, fn {u, cur}, {rows, ans} ->
          ans = if u == n - 1 and cur < ans, do: cur, else: ans

          rows =
            Enum.reduce(elem(adj, u), rows, fn {v, w}, rows ->
              nt = t + w

              if nt <= max_time do
                newc = cur + elem(fees, v)

                Map.update(rows, nt, %{v => newc}, fn rv ->
                  if newc < Map.get(rv, v, inf), do: Map.put(rv, v, newc), else: rv
                end)
              else
                rows
              end
            end)

          {rows, ans}
        end)
      end)

    if ans >= inf, do: -1, else: ans
  end
end
