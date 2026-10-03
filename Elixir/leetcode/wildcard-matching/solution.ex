defmodule Solution do
  @spec is_match(s :: String.t, p :: String.t) :: boolean
  def is_match(s, p) do
    sc = s |> String.to_charlist() |> List.to_tuple()
    pc = p |> String.to_charlist() |> List.to_tuple()
    m = tuple_size(sc)
    n = tuple_size(pc)

    dp = %{{0, 0} => true}

    # First row: empty string matched only by a run of '*'.
    dp =
      Enum.reduce(1..n//1, dp, fn j, dp ->
        if elem(pc, j - 1) == ?* and get(dp, 0, j - 1) do
          Map.put(dp, {0, j}, true)
        else
          dp
        end
      end)

    dp =
      Enum.reduce(1..m//1, dp, fn i, dp ->
        Enum.reduce(1..n//1, dp, fn j, dp ->
          pj = elem(pc, j - 1)

          val =
            cond do
              pj == elem(sc, i - 1) or pj == ?? -> get(dp, i - 1, j - 1)
              pj == ?* -> get(dp, i - 1, j) or get(dp, i, j - 1)
              true -> false
            end

          if val, do: Map.put(dp, {i, j}, val), else: dp
        end)
      end)

    get(dp, m, n)
  end

  defp get(dp, i, j), do: Map.get(dp, {i, j}, false)
end
