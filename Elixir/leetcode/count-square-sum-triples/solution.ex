defmodule Solution do
  @spec count_triples(n :: integer) :: integer
  def count_triples(n) do
    Enum.reduce(1..n, 0, fn a, acc ->
      Enum.reduce(a..n, acc, fn b, acc2 ->
        c_square = a * a + b * b
        c = trunc(:math.sqrt(c_square))

        if c <= n and c * c == c_square do
          acc2 + 2
        else
          acc2
        end
      end)
    end)
  end
end
