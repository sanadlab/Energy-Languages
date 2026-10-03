defmodule Solution do
  @spec min_operations(s :: String.t) :: integer
  def min_operations(s) do
    chars = String.to_charlist(s)
    n = length(chars)

    cnt =
      chars
      |> Enum.with_index()
      |> Enum.count(fn {ch, i} ->
        expected = if rem(i, 2) == 0, do: ?0, else: ?1
        ch != expected
      end)

    min(cnt, n - cnt)
  end
end
