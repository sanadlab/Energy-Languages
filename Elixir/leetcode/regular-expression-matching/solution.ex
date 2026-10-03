defmodule Solution do
  @spec is_match(s :: String.t, p :: String.t) :: boolean
  def is_match(s, p) do
    sc = s |> String.to_charlist() |> List.to_tuple()
    pc = p |> String.to_charlist() |> List.to_tuple()
    m = tuple_size(sc)
    n = tuple_size(pc)

    dp = %{{m, n} => true}

    dp =
      Enum.reduce(m..0//-1, dp, fn i, dp ->
        if n == 0 do
          dp
        else
          Enum.reduce((n - 1)..0//-1, dp, fn j, dp ->
            first = i < m and (elem(pc, j) == elem(sc, i) or elem(pc, j) == ?.)

            val =
              if j + 1 < n and elem(pc, j + 1) == ?* do
                get(dp, i, j + 2) or (first and get(dp, i + 1, j))
              else
                first and get(dp, i + 1, j + 1)
              end

            Map.put(dp, {i, j}, val)
          end)
        end
      end)

    get(dp, 0, 0)
  end

  defp get(dp, i, j), do: Map.get(dp, {i, j}, false)
end
