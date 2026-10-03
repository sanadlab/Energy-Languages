# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Joerg Baumann).
# Reads FASTA from stdin; for each record, complements each base,
# reverses the whole strand, and rewraps at 60 columns.
# Single-threaded, deterministic output.

defmodule RevComp do
  @from ~c"ABCDGHKMNRSTUVWYabcdghkmnrstuvwy"
  @to ~c"TVGHCDMKNYSAABWRTVGHCDMKNYSAABWR"

  defp build_table do
    base = List.to_tuple(Enum.to_list(0..255))
    Enum.zip(@from, @to) |> Enum.reduce(base, fn {f, t}, tbl -> put_elem(tbl, f, t) end)
  end

  # Complement every base and reverse in one pass: prepending each complemented
  # byte to the accumulator yields reverse(complement(body)). Newlines, carriage
  # returns and spaces are dropped (as Python's translate delete-set does).
  defp rev_complement(body, table) do
    body
    |> :binary.bin_to_list()
    |> Enum.reduce([], fn b, acc ->
      if b == ?\n or b == ?\r or b == ?\s, do: acc, else: [elem(table, b) | acc]
    end)
    |> :binary.list_to_bin()
  end

  defp wrap(rc), do: wrap(rc, byte_size(rc), [])

  defp wrap(_rc, 0, acc), do: Enum.reverse(acc)

  defp wrap(rc, remaining, acc) when remaining <= 60 do
    off = byte_size(rc) - remaining
    wrap(rc, 0, [binary_part(rc, off, remaining) | acc])
  end

  defp wrap(rc, remaining, acc) do
    off = byte_size(rc) - remaining
    wrap(rc, remaining - 60, [binary_part(rc, off, 60) | acc])
  end

  defp emit(header, body, table) do
    IO.binwrite(:stdio, [header, ?\n])
    rc = rev_complement(body, table)

    if byte_size(rc) > 0 do
      lines = wrap(rc)
      IO.binwrite(:stdio, [Enum.intersperse(lines, ?\n), ?\n])
    end
  end

  def run do
    :io.setopts(:standard_io, encoding: :latin1)
    table = build_table()
    data = IO.binread(:stdio, :eof)

    {header, body} =
      data
      |> :binary.split("\n", [:global])
      |> Enum.reduce({nil, []}, fn line, {header, body} ->
        cond do
          line == "" ->
            {header, body}

          :binary.at(line, 0) == ?> ->
            if header, do: emit(header, IO.iodata_to_binary(Enum.reverse(body)), table)
            {line, []}

          true ->
            {header, [line | body]}
        end
      end)

    if header, do: emit(header, IO.iodata_to_binary(Enum.reverse(body)), table)
  end
end

RevComp.run()
