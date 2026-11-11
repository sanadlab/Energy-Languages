# Full-suite correctness validator (Elixir). Runs solution.ex against EVERY
# reference case and compares each result to the expected output. Run FROM the
# cell dir:  elixir ../../../selection/validate_suite.exs
# Reuses elixir_hns.exs so correctness judges the exact same shared inputs the
# measurement harness does. Prints one VALIDATE line to stderr. Exit:
#   0 Accepted, 1 Wrong Answer, 3 Runtime Error, 2 setup error.

Code.require_file("elixir_hns.exs", __DIR__)

defmodule Validate do
  @unordered ~w(uncommon-words-from-two-sentences remove-invalid-parentheses restore-the-array-from-adjacent-pairs ambiguous-coordinates)

  def main do
    cell = File.cwd!()
    slug = Path.basename(cell)
    ref = Path.join([cell, "..", "..", "..", "reference", "leetcode"])

    try do
      out = HNS.parse_ordered(File.read!(Path.join([ref, "outputs", slug <> ".json"])))
      wl = HNS.parse_ordered(File.read!(Path.join([ref, "workloads", slug <> ".json"])))
      camel = HNS.obj_get(wl, "entry_point") |> to_string() |> String.split(".") |> List.last()
      Code.compiler_options(ignore_module_conflict: true)
      Code.require_file("solution.ex", cell)
      run(slug, {camel, HNS.char_specs(cell)}, HNS.obj_get(out, "expected"))
    rescue
      e -> IO.puts(:stderr, "VALIDATE slug=#{slug} ERROR load: #{Exception.message(e)}"); System.halt(2)
    end
  end

  # fun = {camel, specs}: the entry point's name and the snippet's char types.
  defp run(slug, fun, expected) do
    total = length(expected)
    randomized = slug == "random-pick-index"
    expected
    |> Enum.with_index()
    |> Enum.each(fn {c, i} ->
      name = HNS.obj_get(c, "name")
      inp = HNS.obj_get(c, "input")
      is_design = HNS.design?(inp)
      exp = expected_chars(inp, HNS.obj_get(c, "output"), fun)

      actual =
        try do
          run_case(inp, fun, randomized)
        rescue
          e -> fail_re(slug, name, i, total, e)
        catch
          kind, reason -> fail_re(slug, name, i, total, {kind, reason})
        end

      ok =
        cond do
          is_design -> seq_ok(actual, exp)
          slug in @unordered -> unordered_eq(actual, exp)
          true -> HNS.eq(actual, exp)
        end

      unless ok do
        IO.puts(:stderr, "VALIDATE slug=#{slug} FAIL case=#{name} passed=#{i} ncases=#{total} " <>
          "expected=#{String.slice(HNS.canon(exp), 0, 120)} actual=#{String.slice(HNS.canon(actual), 0, 120)}")
        System.halt(1)
      end
    end)

    IO.puts(:stderr, "VALIDATE slug=#{slug} PASS ncases=#{total} passed=#{total}")
    System.halt(0)
  end

  defp fail_re(slug, name, i, total, e) do
    IO.puts(:stderr, "VALIDATE slug=#{slug} RE case=#{name} passed=#{i} ncases=#{total} #{inspect(e)}")
    System.halt(3)
  end

  defp run_case(inp, {camel, specs}, randomized) do
    if HNS.design?(inp) do
      [op0 | rest_ops] = HNS.obj_get(inp, "ops")
      [a0 | rest_args] = HNS.obj_get(inp, "args")
      mod = Module.concat([op0])
      nums = if randomized, do: hd(a0), else: nil
      apply(mod, :init_, HNS.op_args(a0, specs, :init_))
      seq =
        Enum.zip(rest_ops, rest_args)
        |> Enum.map(fn {op, a} ->
          r = apply(mod, HNS.resolve(mod, op, length(a)), HNS.op_args(a, specs, HNS.snake_atom(op)))
          if randomized and op == "pick" and is_integer(r) and nums, do: Enum.at(nums, r), else: r
        end)
      [nil | seq]
    else
      args = HNS.build_args(inp, HNS.param_chars(specs, HNS.snake_atom(camel)))
      apply(Solution, HNS.resolve(Solution, camel, length(args)), args)
    end
  end

  # The expected output with each char result as its code point.
  defp expected_chars(inp, exp, {camel, specs}) do
    if HNS.design?(inp) do
      [_op0 | rest_ops] = HNS.obj_get(inp, "ops")
      [e0 | rest_exp] = exp
      [e0 | Enum.zip_with(rest_ops, rest_exp, fn op, e -> HNS.charify(e, HNS.ret_chars(specs, HNS.snake_atom(op))) end)]
    else
      HNS.charify(exp, HNS.ret_chars(specs, HNS.snake_atom(camel)))
    end
  end

  defp seq_ok(actual, expected) when is_list(actual) and is_list(expected) and length(actual) == length(expected) do
    Enum.zip(actual, expected) |> Enum.all?(fn {a, e} -> e == nil or HNS.eq(a, e) end)
  end
  defp seq_ok(_, _), do: false

  defp unordered_eq(a, e) when is_list(a) and is_list(e) do
    Enum.sort(Enum.map(a, &HNS.canon/1)) == Enum.sort(Enum.map(e, &HNS.canon/1))
  end
  defp unordered_eq(a, e), do: HNS.canon(a) == HNS.canon(e)
end

Validate.main()
