defmodule Solution do
  @spec earliest_and_latest(n :: integer, first_player :: integer, second_player :: integer) :: [integer]
  def earliest_and_latest(n, first_player, second_player) do
    Process.put(:memo, %{})
    {e, l} = dp(n, first_player, second_player)
    [e, l]
  end

  defp dp(m, f0, s0) do
    {f, s} = if f0 > s0, do: {s0, f0}, else: {f0, s0}
    key = {m, f, s}

    case Map.get(Process.get(:memo), key) do
      nil ->
        result = compute(m, f, s)
        Process.put(:memo, Map.put(Process.get(:memo), key, result))
        result

      cached ->
        cached
    end
  end

  defp compute(m, f, s) do
    if f + s == m + 1 do
      {1, 1}
    else
      new_m = div(m + 1, 2)

      groups =
        Enum.reduce(1..div(m, 2), [], fn p, acc ->
          q = m + 1 - p

          g =
            cond do
              f == p or f == q -> [f]
              s == p or s == q -> [s]
              true -> [p, q]
            end

          [g | acc]
        end)
        |> Enum.reverse()

      groups = if rem(m, 2) == 1, do: groups ++ [[div(m + 1, 2)]], else: groups

      outcomes =
        groups
        |> cartesian()
        |> Enum.reduce(MapSet.new(), fn combo, set ->
          below_f = Enum.count(combo, fn w -> w < f end)
          below_s = Enum.count(combo, fn w -> w < s end)
          MapSet.put(set, {below_f + 1, below_s + 1})
        end)

      Enum.reduce(outcomes, {1_000_000, -1_000_000}, fn {nf, ns}, {earliest, latest} ->
        {e, l} = dp(new_m, nf, ns)
        {min(earliest, e + 1), max(latest, l + 1)}
      end)
    end
  end

  defp cartesian([]), do: [[]]

  defp cartesian([h | t]) do
    rest = cartesian(t)
    for x <- h, r <- rest, do: [x | r]
  end
end
