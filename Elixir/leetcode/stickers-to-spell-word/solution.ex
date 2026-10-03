defmodule Solution do
  import Bitwise

  @spec min_stickers(stickers :: [String.t], target :: String.t) :: integer
  def min_stickers(stickers, target) do
    tgt = target |> String.to_charlist() |> Enum.map(&(&1 - ?a)) |> List.to_tuple()
    n = tuple_size(tgt)
    full = (1 <<< n) - 1
    inf = 1 <<< 30

    zero26 = List.to_tuple(List.duplicate(0, 26))

    cnt =
      Enum.map(stickers, fn s ->
        s
        |> String.to_charlist()
        |> Enum.reduce(zero26, fn ch, acc ->
          idx = ch - ?a
          put_elem(acc, idx, elem(acc, idx) + 1)
        end)
      end)

    dp =
      Enum.reduce(0..full, %{0 => 0}, fn state, dp ->
        case Map.get(dp, state) do
          nil ->
            dp

          cost ->
            Enum.reduce(cnt, dp, fn c, dp ->
              nxt = fill(c, state, tgt, n)
              cur = Map.get(dp, nxt, inf)
              if cost + 1 < cur, do: Map.put(dp, nxt, cost + 1), else: dp
            end)
        end
      end)

    case Map.get(dp, full) do
      nil -> -1
      v -> v
    end
  end

  defp fill(c, state, tgt, n) do
    {nxt, _avail} =
      Enum.reduce(0..(n - 1), {state, c}, fn i, {nxt, avail} ->
        if (state &&& 1 <<< i) == 0 do
          idx = elem(tgt, i)

          if elem(avail, idx) > 0 do
            {nxt ||| 1 <<< i, put_elem(avail, idx, elem(avail, idx) - 1)}
          else
            {nxt, avail}
          end
        else
          {nxt, avail}
        end
      end)

    nxt
  end
end
