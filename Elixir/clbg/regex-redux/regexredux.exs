# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Dominique Wahli,
# Ahmad Syukri, Justin Peel). Reads FASTA from stdin. Elixir's
# Regex (PCRE) stands in for Python's re; the substitution set is
# applied in a fixed order. Single-threaded, deterministic output.

defmodule RegexRedux do
  @variants [
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct"
  ]

  # Order matters: Python iterates the dict in insertion order.
  @subst [
    {"tHa[Nt]", "<4>"},
    {"aND|caN|Ha[DS]|WaS", "<3>"},
    {"a[NSt]|BY", "<2>"},
    {"<[^>]*>", "|"},
    {"\\|[^|][^|]*\\|", "-"}
  ]

  def run do
    data = IO.binread(:stdio, :eof)
    ilen = byte_size(data)

    seq = Regex.replace(~r/>.*\n|\n/, data, "")
    clen = byte_size(seq)

    Enum.each(@variants, fn v ->
      count = Regex.scan(Regex.compile!(v), seq) |> length()
      IO.puts("#{v} #{count}")
    end)

    final =
      Enum.reduce(@subst, seq, fn {pat, rep}, s ->
        Regex.replace(Regex.compile!(pat), s, rep)
      end)

    IO.puts("")
    IO.puts(ilen)
    IO.puts(clen)
    IO.puts(byte_size(final))
  end
end

RegexRedux.run()
