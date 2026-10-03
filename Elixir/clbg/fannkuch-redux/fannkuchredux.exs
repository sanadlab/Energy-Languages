# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Joerg Baumann,
# after Oleg Mazurov). Single task over the whole permutation
# range, so the alternating checksum and the maximum flip count
# are computed deterministically and single-threaded. Every task
# start in the parallel Python is even, so the per-task sign reset
# agrees with a single global +/- alternation from index 0.

defmodule FannkuchRedux do
  # Permutation indices are 0-based values 0..n-1 held in a tuple.

  defp factorial(n), do: Enum.reduce(1..n, 1, &(&1 * &2))

  defp swap01(p), do: p |> put_elem(0, elem(p, 1)) |> put_elem(1, elem(p, 0))

  # Count the number of prefix reversals until p[0] == 0.
  defp flips(p) do
    case elem(p, 0) do
      0 -> 0
      first -> do_flips(p, first, 1)
    end
  end

  defp do_flips(p, first, c) do
    p2 = rev_prefix(p, 0, first)

    case elem(p2, 0) do
      0 -> c
      nf -> do_flips(p2, nf, c + 1)
    end
  end

  defp rev_prefix(p, lo, hi) when lo >= hi, do: p

  defp rev_prefix(p, lo, hi) do
    p
    |> put_elem(lo, elem(p, hi))
    |> put_elem(hi, elem(p, lo))
    |> rev_prefix(lo + 1, hi - 1)
  end

  # rotation_swaps[i] = [{dst, src}, ...] describing p[dst] = t[src] for the
  # i-th factorial-odometer step (left-rotate of the first v+1 elements for
  # v = 1..i, cumulatively). Returned as a tuple indexed by i (1..n-1).
  defp rotation_swaps(n) do
    for i <- 0..(n - 1) do
      if i < 1 do
        []
      else
        r = Enum.reduce(1..i, Enum.to_list(0..(n - 1)), fn v, r -> rotate_prefix(r, v + 1) end)

        r
        |> Enum.with_index()
        |> Enum.filter(fn {src, dst} -> dst != src end)
        |> Enum.map(fn {src, dst} -> {dst, src} end)
      end
    end
    |> List.to_tuple()
  end

  defp rotate_prefix(list, m) do
    {[h | t], back} = Enum.split(list, m)
    t ++ [h] ++ back
  end

  # Factorial-number-system odometer: find the position to increment,
  # resetting lower positions, starting at i=2.
  defp bump(count, i) do
    if elem(count, i) >= i do
      bump(put_elem(count, i, 0), i + 1)
    else
      {i, put_elem(count, i, elem(count, i) + 1)}
    end
  end

  defp apply_rot(rs, i, t) do
    Enum.reduce(elem(rs, i), t, fn {dst, src}, acc -> put_elem(acc, dst, elem(t, src)) end)
  end

  defp loop(k, _p, _count, maxf, chk, iters, _rs) when k == iters, do: {chk, maxf}

  defp loop(k, p, count, maxf, chk, iters, rs) do
    fa = flips(p)
    p2 = swap01(p)
    fb = flips(p2)
    maxf2 = max(maxf, max(fa, fb))
    chk2 = chk + fa - fb

    if k + 1 == iters do
      {chk2, maxf2}
    else
      {i, count2} = bump(count, 2)
      loop(k + 1, apply_rot(rs, i, p2), count2, maxf2, chk2, iters, rs)
    end
  end

  def run(n) do
    total = factorial(n)
    p = List.to_tuple(Enum.to_list(0..(n - 1)))
    count = Tuple.duplicate(0, n)
    rs = rotation_swaps(n)
    {checksum, maximum} = loop(0, p, count, 0, 0, div(total, 2), rs)
    IO.puts("#{checksum}\nPfannkuchen(#{n}) = #{maximum}")
  end
end

n = System.argv() |> hd() |> String.to_integer()
FannkuchRedux.run(n)
