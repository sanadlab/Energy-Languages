defmodule Solution do
  @spec next_beautiful_number(n :: integer) :: integer
  def next_beautiful_number(n) do
    find(n + 1)
  end

  defp find(x) do
    if balanced?(x), do: x, else: find(x + 1)
  end

  defp balanced?(x) do
    x
    |> count_digits(%{})
    |> Enum.all?(fn {d, c} -> c == d end)
  end

  defp count_digits(0, acc), do: acc

  defp count_digits(t, acc) do
    d = rem(t, 10)
    count_digits(div(t, 10), Map.update(acc, d, 1, &(&1 + 1)))
  end
end
