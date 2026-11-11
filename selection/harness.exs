# Generic Elixir loop-harness for the per-op cross-language measurement.
# Reads the SAME shared JSON inputs as the Python/Ruby harnesses and loops the
# call of the cell's solution to a wall-time budget (checksum-folded,
# iteration-counted). Elixir is immutable, so plain-data args can be reused every
# iteration (no deep-copy); only tree/list need construction.
#
# This file only defines the Harness module; it has no top-level code, so the
# build compiles it (with elixir_hns.exs) and a measured run only starts it:
#   build: elixirc -o .perf_build elixir_hns.exs harness.exs; then solution.ex
#   run:   elixir -pa .perf_build -e 'Harness.main()' <budget_seconds> <case_index>
#   (run FROM the cell dir; slug derived from the dir name)
#   prints CASE/ITERS/ACC/MEAS_S/BEACON to STDERR (stdout stays empty).
#
# Design (stateful) problems hold state in the process dictionary, LeetCode's
# Elixir convention; init_ is called (and the dict cleared) before each replay.

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
    specs = HNS.char_specs(cell)

    warm = budget * 0.3
    randomized = slug == "random-pick-index"

    {one, beacon_str} =
      if HNS.design?(input) do
        {design_closure(input, HNS.obj_get(kase, "output"), specs), "design"}
      else
        camel = HNS.obj_get(HNS.parse_ordered(File.read!(Path.join([ref, "workloads", slug <> ".json"]))), "entry_point")
                |> to_string() |> String.split(".") |> List.last()
        args = HNS.build_args(input, HNS.param_chars(specs, HNS.snake_atom(camel)))
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

  # A design replay: init_, then fold every op result. Returns an integer (a
  # per-replay checksum) so the measure loop never folds a large result list.
  # Every op's function and args are resolved once, before timing, and an op
  # whose expected output is null (a void op; its return value is the
  # solution's choice) folds null, as in the other languages.
  defp design_closure(input, expected, specs) do
    [op0 | rest_ops] = HNS.obj_get(input, "ops")
    [a0 | rest_args] = HNS.obj_get(input, "args")
    mod = Module.concat([op0])
    a0c = HNS.op_args(a0, specs, :init_)
    calls =
      Enum.zip([rest_ops, rest_args, tl(expected)])
      |> Enum.map(fn {op, a, e} ->
        {HNS.resolve(mod, op, length(a)), HNS.op_args(a, specs, HNS.snake_atom(op)), e == nil}
      end)
    fn ->
      # init_ resets the solution's own process-dictionary state (LeetCode
      # convention); do NOT clear the whole dict — that erases the Elixir
      # runtime's own bookkeeping keys.
      apply(mod, :init_, a0c)
      Enum.reduce(calls, 0, fn {f, a, void}, acc ->
        r = apply(mod, f, a)
        HNS.fold(acc, if(void, do: nil, else: r))
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
