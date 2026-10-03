defmodule Solution do
  @spec str_without3a3b(a :: integer, b :: integer) :: String.t
  def str_without3a3b(a, b) do
    build(a, b, [])
    |> Enum.reverse()
    |> List.to_string()
  end

  # `rev` holds the characters written so far in REVERSE order, so its head is
  # the last written char (res[-1]) and the next element is res[-2].
  defp build(a, b, rev) when a <= 0 and b <= 0, do: rev

  defp build(a, b, rev) do
    write_a =
      case rev do
        [x, y | _] when x == y -> x == ?b
        _ -> a >= b
      end

    cond do
      write_a and a == 0 -> rev
      write_a -> build(a - 1, b, [?a | rev])
      b == 0 -> rev
      true -> build(a, b - 1, [?b | rev])
    end
  end
end
