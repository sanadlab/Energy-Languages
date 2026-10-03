# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Ian Osgood,
# Heinrich Acker, Justin Peel, Christopher Sean Forgeron).
# The LCG is driven with exact integer arithmetic (the Python
# float LCG only ever holds exact integers), and the character
# lookup replicates bisect_right over the cumulative table.
# Single-threaded, deterministic output.

defmodule Fasta do
  @alu "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" <>
         "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" <>
         "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" <>
         "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" <>
         "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" <>
         "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" <>
         "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

  @iub Enum.zip(
         ~c"acgtBDHKMNRSVWY",
         [0.27, 0.12, 0.12, 0.27] ++ List.duplicate(0.02, 11)
       )

  @homosapiens [
    {?a, 0.3029549426680},
    {?c, 0.1979883004921},
    {?g, 0.1975473066391},
    {?t, 0.3015094502008}
  ]

  @im 139968

  # cumulative probability list + matching char-code list, summed in order.
  defp make_cumulative(table) do
    {probs_rev, chars_rev, _} =
      Enum.reduce(table, {[], [], 0.0}, fn {ch, p}, {ps, cs, prob} ->
        prob = prob + p
        {[prob | ps], [ch | cs], prob}
      end)

    {Enum.reverse(probs_rev), Enum.reverse(chars_rev)}
  end

  defp repeat_fasta(src, n) do
    l = byte_size(src)
    ss = src <> src <> binary_part(src, 0, rem(n, l))
    full = div(n, 60)

    Enum.each(0..(full - 1)//1, fn count ->
      i = rem(count * 60, l)
      IO.binwrite(:stdio, [binary_part(ss, i, 60), ?\n])
    end)

    r = rem(n, 60)

    if r != 0 do
      IO.binwrite(:stdio, [binary_part(ss, byte_size(ss) - r, r), ?\n])
    end
  end

  defp random_fasta(table, n, seed) do
    {probs, chars} = make_cumulative(table)
    full = div(n, 60)

    seed =
      Enum.reduce(0..(full - 1)//1, seed, fn _, seed ->
        {line, seed} = gen_chars(60, seed, probs, chars, [])
        IO.binwrite(:stdio, [line, ?\n])
        seed
      end)

    r = rem(n, 60)

    if r != 0 do
      {line, seed} = gen_chars(r, seed, probs, chars, [])
      IO.binwrite(:stdio, [line, ?\n])
      seed
    else
      seed
    end
  end

  defp gen_chars(0, seed, _probs, _chars, acc), do: {Enum.reverse(acc), seed}

  defp gen_chars(k, seed, probs, chars, acc) do
    seed = rem(seed * 3877 + 29573, @im)
    rv = seed / 139968.0
    idx = Enum.count(probs, &(&1 <= rv))
    gen_chars(k - 1, seed, probs, chars, [Enum.at(chars, idx) | acc])
  end

  def run(n) do
    :io.setopts(:standard_io, encoding: :latin1)
    IO.binwrite(:stdio, ">ONE Homo sapiens alu\n")
    repeat_fasta(@alu, n * 2)
    IO.binwrite(:stdio, ">TWO IUB ambiguity codes\n")
    seed = random_fasta(@iub, n * 3, 42)
    IO.binwrite(:stdio, ">THREE Homo sapiens frequency\n")
    random_fasta(@homosapiens, n * 5, seed)
  end
end

n = System.argv() |> hd() |> String.to_integer()
Fasta.run(n)
