# Build an Elixir CLBG program ONCE (`make compile`), so that a measured run
# (`make run`) only starts compiled modules and never compiles:
#
#   elixir clbg_elixir_build.exs <source.exs> <out_dir>
#   run: elixir -pa <out_dir> -e PerfArena.ClbgMain.main <N>
#
# The program can have either shape:
#   * a script: modules, then top-level code that runs them (for example
#     `NBody.run(n)` with n from System.argv());
#   * modules only, one of which defines main/1 (it gets System.argv()).
# The modules are compiled as they are. The top-level code (or the call of
# main/1) becomes PerfArena.ClbgMain.main/0. A top-level import, alias, or
# require stays where it is (it applies to the modules after it) and is also
# kept in its place among the top-level code.

[src, out] = System.argv()

forms =
  case Code.string_to_quoted!(File.read!(src), file: src) do
    {:__block__, _, fs} -> fs
    f -> [f]
  end

kind = fn
  {d, _, _} when d in [:defmodule, :defprotocol, :defimpl] -> :module
  {:use, _, _} -> :use
  {d, _, _} when d in [:import, :alias, :require] -> :directive
  _ -> :code
end

File.mkdir_p!(out)
write = fn mods -> for {m, bin} <- mods, do: File.write!(Path.join(out, "#{m}.beam"), bin) end

# 1. the program's modules, with the top-level directives before them
mods = Code.compile_quoted({:__block__, [], Enum.filter(forms, &(kind.(&1) != :code))}, src)
write.(mods)

# 2. the entry point: the top-level code, else a call of the main/1 the
#    program defines (the modules are loaded now)
main_forms =
  if Enum.any?(forms, &(kind.(&1) == :code)) do
    Enum.filter(forms, &(kind.(&1) in [:directive, :code]))
  else
    case for({m, _} <- mods, function_exported?(m, :main, 1), do: m) do
      [] ->
        IO.puts(:stderr, "#{src}: no entry point: no top-level code and no module with main/1")
        System.halt(1)

      ms ->
        [quote(do: unquote(List.last(ms)).main(System.argv()))]
    end
  end

entry =
  quote do
    defmodule PerfArena.ClbgMain do
      @moduledoc false
      def main do
        unquote_splicing(main_forms)
      end
    end
  end

write.(Code.compile_quoted(entry, src))
