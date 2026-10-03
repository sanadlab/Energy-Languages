# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Joerg Baumann).
# Reads FASTA from stdin, takes the THREE sequence, and reports
# 1-mer and 2-mer frequencies (percent, sorted) plus the counts of
# five fixed k-mers (every overlapping reading frame).
# Single-threaded, deterministic output.

defmodule KNucleotide do
  @bases [?A, ?C, ?G, ?T]

  # Read the body following the ">THREE" header, drop newlines, uppercase.
  defp read_three(data) do
    lines = :binary.split(data, "\n", [:global])

    body =
      lines
      |> Enum.drop_while(fn l -> not starts_with_three?(l) end)
      |> Enum.drop(1)
      |> Enum.take_while(fn l -> l == "" or :binary.at(l, 0) != ?> end)
      |> IO.iodata_to_binary()

    upcase(body)
  end

  defp starts_with_three?(l) do
    byte_size(l) >= 6 and :binary.part(l, 0, 6) == ">THREE"
  end

  defp upcase(bin) do
    for <<c <- bin>>, into: <<>> do
      if c >= ?a and c <= ?z, do: <<c - 32>>, else: <<c>>
    end
  end

  defp fmt_pct(count, n), do: :erlang.float_to_binary(count * 100.0 / n, decimals: 3)

  # Overlapping count of every k-mer (sliding window of size k).
  defp kmer_freq(seq, k) do
    l = byte_size(seq)
    if l < k, do: %{}, else: tally(seq, k, 0, l - k, %{})
  end

  defp tally(_seq, _k, i, maxi, acc) when i > maxi, do: acc

  defp tally(seq, k, i, maxi, acc) do
    key = binary_part(seq, i, k)
    tally(seq, k, i + 1, maxi, Map.update(acc, key, 1, &(&1 + 1)))
  end

  defp count_overlap(seq, target) do
    kmer_freq(seq, byte_size(target)) |> Map.get(target, 0)
  end

  defp display(labels, freq, n) do
    labels
    |> Enum.map(fn label -> {label, Map.get(freq, label, 0)} end)
    |> Enum.sort_by(fn {label, count} -> {-count, label} end)
    |> Enum.each(fn {label, count} -> IO.puts("#{label} #{fmt_pct(count, n)}") end)

    IO.puts("")
  end

  def run do
    seq = read_three(IO.binread(:stdio, :eof))
    l = byte_size(seq)

    mono = kmer_freq(seq, 1)
    di = kmer_freq(seq, 2)

    display(Enum.map(@bases, &<<&1>>), mono, l)
    display(for(x <- @bases, y <- @bases, do: <<x, y>>), di, l - 1)

    ["GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"]
    |> Enum.each(fn t -> IO.puts("#{count_overlap(seq, t)}\t#{t}") end)
  end
end

KNucleotide.run()
