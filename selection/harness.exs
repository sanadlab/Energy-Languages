# Generic Elixir loop-harness for the per-op cross-language measurement.
# Reads the SAME shared JSON inputs as the Python/Ruby harnesses, compiles the
# cell's solution.ex, and loops the call to a wall-time budget (checksum-folded,
# iteration-counted). Elixir is immutable, so plain-data args can be reused every
# iteration (no deep-copy); only tree/list need construction.
#
#   elixir ../../../selection/harness.exs <budget_seconds> <case_index>
#   (run FROM the cell dir; slug derived from the dir name)
#   prints CASE/ITERS/ACC/MEAS_S/BEACON to STDERR (stdout stays empty).
#
# Design (stateful) problems hold state in the process dictionary, LeetCode's
# Elixir convention; init_ is called (and the dict cleared) before each replay.

Code.require_file("elixir_hns.exs", __DIR__)

defmodule Harness do
  def main do
    [budget_s, idx_s] = System.argv()
    budget = String.to_float(ensure_float(budget_s))
    idx = String.to_integer(idx_s)
    cell = File.cwd!()
    slug = Path.basename(cell)
    ref = Path.join([cell, "..", "..", "..", "reference", "leetcode"])

    out = HNS.parse_ordered(File.read!(Path.join([ref, "outputs", slug <> ".json"])))
    kase = Enum.at(HNS.obj_get(out, "expected"), idx)
    name = HNS.obj_get(kase, "name")
    input = HNS.obj_get(kase, "input")

    Code.compiler_options(ignore_module_conflict: true)
    Code.require_file("solution.ex", cell)

    warm = budget * 0.3
    randomized = slug == "random-pick-index"

    {one, beacon_str} =
      if HNS.design?(input) do
        {design_closure(input), "design"}
      else
        camel = HNS.obj_get(HNS.parse_ordered(File.read!(Path.join([ref, "workloads", slug <> ".json"]))), "entry_point")
                |> to_string() |> String.split(".") |> List.last()
        args = HNS.build_args(input)
        meth = HNS.resolve(Solution, camel, length(args))
        beacon = apply(Solution, meth, args)
        {fn -> apply(Solution, meth, args) end, String.slice(HNS.canon(beacon), 0, 80)}
      end

    _ = randomized

    # estimate per-iter cost during warmup, then batch the wall-clock read
    t0 = mono()
    wi = warm_loop(one, t0 + round(warm * 1_000_000), 0)
    per_us = if wi > 0, do: (mono() - t0) / wi, else: warm * 1_000_000
    batch = if per_us > 0, do: min(max(trunc(2000 / per_us), 1), 4096), else: 4096

    tm = mono()
    deadline = tm + round((budget - warm) * 1_000_000)
    {acc, iters} = measure_loop(one, deadline, 0, 0, batch)
    meas = (mono() - tm) / 1_000_000

    IO.puts(:stderr, "CASE=#{name} ITERS=#{iters} ACC=#{acc} MEAS_S=#{fmt(meas)} BEACON=#{beacon_str}")
  end

  # A design replay: clear state, init_, then fold every op result. Returns an
  # integer (a per-replay checksum) so the measure loop never canonicalizes a
  # large result list. Uses zip (NOT Enum.at) to stay O(ops).
  defp design_closure(input) do
    [op0 | rest_ops] = HNS.obj_get(input, "ops")
    [a0 | rest_args] = HNS.obj_get(input, "args")
    mod = Module.concat([op0])
    pairs = Enum.zip(rest_ops, rest_args)
    fn ->
      # init_ resets the solution's own process-dictionary state (LeetCode
      # convention); do NOT clear the whole dict — that erases the Elixir
      # runtime's own bookkeeping keys.
      apply(mod, :init_, a0)
      Enum.reduce(pairs, 0, fn {op, a}, acc ->
        HNS.fold(acc, apply(mod, HNS.resolve(mod, op, length(a)), a))
      end)
    end
  end

  defp mono, do: System.monotonic_time(:microsecond)

  defp warm_loop(one, deadline, n) do
    if mono() >= deadline do
      n
    else
      one.()
      warm_loop(one, deadline, n + 1)
    end
  end

  defp measure_loop(one, deadline, acc, iters, batch) do
    if mono() >= deadline do
      {acc, iters}
    else
      measure_loop(one, deadline, do_batch(one, acc, batch), iters + batch, batch)
    end
  end

  defp do_batch(_one, acc, 0), do: acc
  defp do_batch(one, acc, k), do: do_batch(one, HNS.fold(acc, one.()), k - 1)

  defp ensure_float(s), do: if(String.contains?(s, "."), do: s, else: s <> ".0")
  defp fmt(x), do: :erlang.float_to_binary(x * 1.0, decimals: 6)
end

Harness.main()
