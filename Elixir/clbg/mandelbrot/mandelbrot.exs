# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir to match the reference PBM output (the
# C#/Dart calculation block by Isaac Gouy, Antti Lankila,
# The Anh Tran, Robert F. Tobler and Jos Hirth): 50-step escape
# test via a 49-count do-while, |z|^2 threshold 4.0, bits packed
# MSB-first. Single-threaded, deterministic binary output.

defmodule Mandelbrot do
  def run(n) do
    # stdout defaults to :unicode, which UTF-8-expands bytes >= 0x80 and
    # corrupts the packed PBM. Force raw single-byte output.
    :io.setopts(:standard_io, encoding: :latin1)
    IO.binwrite(:stdio, "P4\n#{n} #{n}\n")
    Enum.each(0..(n - 1), fn y -> IO.binwrite(:stdio, calc_line(n, y)) end)
  end

  defp calc_line(n, y) do
    ci = y * 2.0 / n - 1.0

    0..(n - 1)
    |> Enum.map(fn x -> pixel_bit(x * 2.0 / n - 1.5, ci) end)
    |> Enum.chunk_every(8)
    |> Enum.map(&byte_of/1)
    |> :erlang.list_to_binary()
  end

  # MSB-first packing; a short final chunk pads its low bits with 0.
  defp byte_of(chunk) do
    {acc, cnt} = Enum.reduce(chunk, {0, 0}, fn b, {a, c} -> {a * 2 + b, c + 1} end)
    :erlang.bsl(acc, 8 - cnt)
  end

  defp pixel_bit(cr, ci), do: iterate(cr, ci, cr * cr, ci * ci, cr, ci, 49)

  # Mirrors Dart's `do {...} while ((tr+ti <= 4.0) && (--i > 0))`: the escape
  # test short-circuits before the counter is decremented, so a point that
  # escapes on the final step is NOT in the set.
  defp iterate(zr, zi, tr, ti, cr, ci, i) do
    zi2 = zr * zi + zr * zi + ci
    zr2 = tr - ti + cr
    tr2 = zr2 * zr2
    ti2 = zi2 * zi2

    cond do
      tr2 + ti2 > 4.0 -> 0
      i - 1 == 0 -> 1
      true -> iterate(zr2, zi2, tr2, ti2, cr, ci, i - 1)
    end
  end
end

n = System.argv() |> hd() |> String.to_integer()
Mandelbrot.run(n)
