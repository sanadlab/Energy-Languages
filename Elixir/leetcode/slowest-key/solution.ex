defmodule Solution do
  @spec slowest_key(release_times :: [integer], keys_pressed :: String.t) :: char
  def slowest_key(release_times, keys_pressed) do
    keys = String.graphemes(keys_pressed)

    durs =
      release_times
      |> Enum.reduce({[], 0}, fn t, {acc, prev} -> {[t - prev | acc], t} end)
      |> elem(0)
      |> Enum.reverse()

    {_dur, best} =
      Enum.zip(durs, keys)
      |> Enum.reduce({-1, ""}, fn {dur, key}, {bd, bk} ->
        if dur > bd or (dur == bd and key > bk) do
          {dur, key}
        else
          {bd, bk}
        end
      end)

    best
  end
end
