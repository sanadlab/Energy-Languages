# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Rene Bakker,
# Isaac Gouy). Uses Elixir's native arbitrary-precision integers
# in place of gmpy2. Single-threaded, deterministic output.

defmodule PiDigits do
  def run(nn) do
    IO.write(loop(4, 3, 1, 1, 0, [], nn))
  end

  defp loop(n1, n2, d, k, i, acc, nn) do
    u = div(n1, d)
    v = div(n2, d)

    if u == v do
      acc = [acc, <<48 + u>>]
      i = i + 1

      acc =
        if rem(i, 10) == 0 do
          [acc, "\t:", Integer.to_string(i), "\n"]
        else
          acc
        end

      if i == nn do
        # end: emit the trailing partial line if the last line is not full
        if rem(i, 10) != 0 do
          pad = 10 - rem(i, 10)
          [acc, String.duplicate(" ", pad), "\t:", Integer.to_string(nn), "\n"]
        else
          acc
        end
      else
        uu = d * (-10 * u)
        loop(n1 * 10 + uu, n2 * 10 + uu, d, k, i, acc, nn)
      end
    else
      k2 = k * 2
      uu = n1 * (k2 - 1)
      vv = n2 + n2
      ww = n1 * (k - 1)
      n1b = uu + vv
      uu2 = n2 * (k + 2)
      n2b = ww + uu2
      db = d * (k2 + 1)
      loop(n1b, n2b, db, k + 1, i, acc, nn)
    end
  end
end

n = System.argv() |> hd() |> String.to_integer()
PiDigits.run(n)
