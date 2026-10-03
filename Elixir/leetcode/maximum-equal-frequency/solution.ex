defmodule Solution do
  @spec max_equal_freq(nums :: [integer]) :: integer
  def max_equal_freq(nums) do
    {_count, _freq, _maxf, res} =
      nums
      |> Enum.with_index()
      |> Enum.reduce({%{}, %{}, 0, 0}, fn {v, i}, {count, freq, maxf, res} ->
        cv = Map.get(count, v, 0)
        freq = if cv > 0, do: Map.put(freq, cv, Map.get(freq, cv, 0) - 1), else: freq
        newcv = cv + 1
        count = Map.put(count, v, newcv)
        freq = Map.put(freq, newcv, Map.get(freq, newcv, 0) + 1)
        maxf = max(maxf, newcv)
        fmax = Map.get(freq, maxf, 0)

        ok =
          maxf == 1 or
            fmax * maxf == i or
            (fmax == 1 and (maxf - 1) * (Map.get(freq, maxf - 1, 0) + 1) == i)

        res = if ok, do: i + 1, else: res
        {count, freq, maxf, res}
      end)

    res
  end
end
