# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Sebastien Loisel,
# Isaac Gouy, Josh Goldfoot, Simon Descarpentries, Jason Stitt).
# Single-threaded, deterministic output.

defmodule SpectralNorm do
  defp eval_a(i, j), do: 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1)

  defp a_times_u(u, n) do
    for i <- 0..(n - 1) do
      Enum.reduce(0..(n - 1), 0.0, fn j, acc -> acc + eval_a(i, j) * elem(u, j) end)
    end
    |> List.to_tuple()
  end

  defp at_times_u(u, n) do
    for i <- 0..(n - 1) do
      Enum.reduce(0..(n - 1), 0.0, fn j, acc -> acc + eval_a(j, i) * elem(u, j) end)
    end
    |> List.to_tuple()
  end

  defp ata(u, n), do: at_times_u(a_times_u(u, n), n)

  def run(n) do
    u0 = Tuple.duplicate(1.0, n)

    {u, v} =
      Enum.reduce(1..10, {u0, u0}, fn _, {u, _} ->
        v = ata(u, n)
        {ata(v, n), v}
      end)

    {vbv, vv} =
      Enum.reduce(0..(n - 1), {0.0, 0.0}, fn i, {vbv, vv} ->
        ue = elem(u, i)
        ve = elem(v, i)
        {vbv + ue * ve, vv + ve * ve}
      end)

    IO.puts(:erlang.float_to_binary(:math.sqrt(vbv / vv), decimals: 9))
  end
end

n = System.argv() |> hd() |> String.to_integer()
SpectralNorm.run(n)
