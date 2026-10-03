defmodule Solution do
  @mod 1_000_000_007

  @spec count_vowel_permutation(n :: integer) :: integer
  def count_vowel_permutation(n) do
    {a, e, i, o, u} =
      Enum.reduce(2..n//1, {1, 1, 1, 1, 1}, fn _, {a, e, i, o, u} ->
        {
          rem(e, @mod),
          rem(a + i, @mod),
          rem(a + e + o + u, @mod),
          rem(i + u, @mod),
          rem(a, @mod)
        }
      end)

    rem(a + e + i + o + u, @mod)
  end
end
