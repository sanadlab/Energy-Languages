defmodule Solution do
  @spec is_scramble(s1 :: String.t, s2 :: String.t) :: boolean
  def is_scramble(s1, s2) do
    if String.length(s1) != String.length(s2) do
      false
    else
      n = String.length(s1)
      t1 = s1 |> String.to_charlist() |> List.to_tuple()
      t2 = s2 |> String.to_charlist() |> List.to_tuple()
      dp = fill(n, t1, t2)
      Map.get(dp, {n, 0, 0}, false)
    end
  end

  defp fill(n, t1, t2) do
    Enum.reduce(1..n//1, %{}, fn length, dp ->
      Enum.reduce(0..(n - length)//1, dp, fn i, dp ->
        Enum.reduce(0..(n - length)//1, dp, fn j, dp ->
          cond do
            not check_equal(t1, t2, i, j, length) ->
              dp

            length == 1 ->
              Map.put(dp, {length, i, j}, true)

            true ->
              ok =
                Enum.any?(1..(length - 1)//1, fn k ->
                  (Map.get(dp, {k, i, j}, false) and
                     Map.get(dp, {length - k, i + k, j + k}, false)) or
                    (Map.get(dp, {k, i, j + length - k}, false) and
                       Map.get(dp, {length - k, i + k, j}, false))
                end)

              if ok, do: Map.put(dp, {length, i, j}, true), else: dp
          end
        end)
      end)
    end)
  end

  defp check_equal(t1, t2, i, j, length) do
    sub_sorted(t1, i, length) == sub_sorted(t2, j, length)
  end

  defp sub_sorted(t, start, length) do
    Enum.sort(for k <- 0..(length - 1)//1, do: elem(t, start + k))
  end
end
