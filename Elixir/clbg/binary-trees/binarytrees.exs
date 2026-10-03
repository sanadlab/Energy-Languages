# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (contributed by
# Antoine Pitrou, Dominique Wahli, Daniel Nanz and Joerg Baumann).
# Single-threaded, deterministic output.

defmodule BinaryTrees do
  def make(0), do: {nil, nil}
  def make(d), do: {make(d - 1), make(d - 1)}

  def check({nil, _}), do: 1
  def check({l, r}), do: 1 + check(l) + check(r)

  defp sum_checks(i, d) do
    Enum.reduce(1..i, 0, fn _, acc -> acc + check(make(d)) end)
  end

  def run(n) do
    min_depth = 4
    max_depth = max(min_depth + 2, n)
    stretch_depth = max_depth + 1

    IO.puts("stretch tree of depth #{stretch_depth}\t check: #{check(make(stretch_depth))}")

    long_lived_tree = make(max_depth)
    mmd = max_depth + min_depth

    min_depth
    |> Stream.iterate(&(&1 + 2))
    |> Stream.take_while(&(&1 < stretch_depth))
    |> Enum.each(fn d ->
      i = :erlang.bsl(1, mmd - d)
      cs = sum_checks(i, d)
      IO.puts("#{i}\t trees of depth #{d}\t check: #{cs}")
    end)

    IO.puts("long lived tree of depth #{max_depth}\t check: #{check(long_lived_tree)}")
  end
end

n = System.argv() |> hd() |> String.to_integer()
BinaryTrees.run(n)
