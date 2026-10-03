# Full-suite correctness validator (Elixir). Runs solution.ex against EVERY
# reference case and compares each result to the expected output. Run FROM the
# cell dir:  elixir ../../../selection/validate_suite.exs
# Reuses elixir_hns.exs so correctness judges the exact same shared inputs the
# measurement harness does. Prints one VALIDATE line to stderr. Exit:
#   0 Accepted, 1 Wrong Answer, 3 Runtime Error, 2 setup error.

Code.require_file("elixir_hns.exs", __DIR__)

defmodule Validate do
  @unordered ~w(uncommon-words-from-two-sentences remove-invalid-parentheses restore-the-array-from-adjacent-pairs)

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
      run(slug, camel, HNS.obj_get(out, "expected"))
    rescue
      e -> IO.puts(:stderr, "VALIDATE slug=#{slug} ERROR load: #{Exception.message(e)}"); System.halt(2)
    end
  end

  defp run(slug, camel, expected) do
    total = length(expected)
    randomized = slug == "random-pick-index"
    expected
    |> Enum.with_index()
    |> Enum.each(fn {c, i} ->
      name = HNS.obj_get(c, "name")
      inp = HNS.obj_get(c, "input")
      exp = HNS.obj_get(c, "output")
      is_design = HNS.design?(inp)

      actual =
        try do
          run_case(inp, camel, randomized)
        rescue
          e -> fail_re(slug, name, i, total, e)
        catch
          kind, reason -> fail_re(slug, name, i, total, {kind, reason})
        end

      ok =
        cond do
          is_design -> seq_ok(actual, exp)
          slug in @unordered -> unordered_eq(actual, exp)
          true -> HNS.canon(actual) == HNS.canon(exp)
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

  defp run_case(inp, camel, randomized) do
    if HNS.design?(inp) do
      [op0 | rest_ops] = HNS.obj_get(inp, "ops")
      [a0 | rest_args] = HNS.obj_get(inp, "args")
      mod = Module.concat([op0])
      nums = if randomized, do: hd(a0), else: nil
      apply(mod, :init_, a0)
      seq =
        Enum.zip(rest_ops, rest_args)
        |> Enum.map(fn {op, a} ->
          r = apply(mod, resolve(mod, op, length(a)), a)
          if randomized and op == "pick" and is_integer(r) and nums, do: Enum.at(nums, r), else: r
        end)
      [nil | seq]
    else
      args = HNS.build_args(inp)
      apply(Solution, resolve(Solution, camel, length(args)), args)
    end
  end

  # snake_case first, camel fallback (both as atoms); default to snake.
  defp resolve(mod, camel, arity) do
    snake = HNS.snake_atom(camel)
    cond do
      function_exported?(mod, snake, arity) -> snake
      function_exported?(mod, String.to_atom(camel), arity) -> String.to_atom(camel)
      true -> snake
    end
  end

  defp seq_ok(actual, expected) when is_list(actual) and is_list(expected) and length(actual) == length(expected) do
    Enum.zip(actual, expected) |> Enum.all?(fn {a, e} -> e == nil or HNS.canon(a) == HNS.canon(e) end)
  end
  defp seq_ok(_, _), do: false

  defp unordered_eq(a, e) when is_list(a) and is_list(e) do
    Enum.sort(Enum.map(a, &HNS.canon/1)) == Enum.sort(Enum.map(e, &HNS.canon/1))
  end
  defp unordered_eq(a, e), do: HNS.canon(a) == HNS.canon(e)
end

Validate.main()
