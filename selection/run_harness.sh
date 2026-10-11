#!/bin/bash
# Unified loop-harness runner: invoke ANY language's shared-input loop harness
# for one case, looped to a wall-time budget. Run FROM the cell directory
# (Energy-Languages/<LangDir>/leetcode/<slug>/). Prints the harness's
# CASE=/ITERS=/ACC=/BEACON= line to stderr; stdout stays empty.
#
#   run_harness.sh <arena_lang> <budget_seconds> <case_index>
#
# arena_lang: python3 cpp java csharp golang javascript typescript php ruby rust kotlin
set -o pipefail
LANG_ARG="$1"; BUDGET="${2:-1.0}"; IDX="${3:-0}"
SEL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# PERFARENA_HARNESS_MODE selects what this call does:
#   all   (default) build if needed, then run. No measurement uses it, because
#         its run would include compilation.
#   build compile the solution and its driver into .perf_build/ (or out/ for
#         C#) and exit; runs nothing. A no-op for interpreted languages. The
#         handler runs it ONCE before measuring any metric.
#   run   run the PREBUILT program and nothing else, via `exec`, so the
#         process this script started IS the measured program.
#   argv  print the command that run mode would exec (NUL-separated) and
#         exit, so every measurement starts the prebuilt program DIRECTLY: Linux keeps
#         a process's peak RSS across exec, so starting it through bash would
#         report bash's own ~3 MB for a solution that uses less. A TypeScript
#         run additionally needs PERFARENA_TS_PREBUILT=1 in its environment.
# Languages without a build/run split exit 3 in build, run, and argv mode, so
# PerfArena does not measure them.
MODE="${PERFARENA_HARNESS_MODE:-all}"

launch() {   # run mode: become the program; argv mode: print its command line
  if [ "$MODE" = argv ]; then printf '%s\0' "$@"; exit 0; fi
  exec "$@"
}

cs_build() {   # C#: build once per solution (content-hash keyed) into out/
  cp "$SEL/Harness.cs" ./Harness.cs
  cat > bench.csproj <<'PROJ'
<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup>
<OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework>
<ImplicitUsings>enable</ImplicitUsings><Nullable>disable</Nullable>
<AssemblyName>bench</AssemblyName><EnableDefaultCompileItems>false</EnableDefaultCompileItems>
</PropertyGroup><ItemGroup><Compile Include="solution.cs"/><Compile Include="Harness.cs"/></ItemGroup></Project>
PROJ
  local h rc=0
  h="$(cksum solution.cs 2>/dev/null | cut -d' ' -f1)"
  if [ ! -f .cs_built ] || [ "$(cat .cs_built 2>/dev/null)" != "$h" ] || [ ! -f out/bench.dll ]; then
    dotnet build bench.csproj -c Release -o out --nologo -v quiet >/dev/null 2>&1 && printf '%s' "$h" > .cs_built
    rc=$?
  fi
  rm -f Harness.cs bench.csproj; rm -rf obj bin
  return $rc
}

if [ "$MODE" = build ] || [ "$MODE" = run ] || [ "$MODE" = argv ]; then
  case "$LANG_ARG" in
    python3|javascript|php|ruby)
      [ "$MODE" = build ] && exit 0
      case "$LANG_ARG" in
        python3)    launch python3 test_suite.py "$BUDGET" "$IDX" ;;
        javascript) launch node "$SEL/harness.js" "$BUDGET" "$IDX" ;;
        php)        launch php -d memory_limit=2G "$SEL/harness.php" "$BUDGET" "$IDX" ;;
        ruby)       launch ruby "$SEL/harness.rb" "$BUDGET" "$IDX" ;;
      esac ;;
    typescript)
      [ "$MODE" = build ] && exec node "$SEL/harness_ts.js" --build
      export PERFARENA_TS_PREBUILT=1
      launch node "$SEL/harness_ts.js" "$BUDGET" "$IDX" ;;
    cpp)
      [ "$MODE" = build ] && exec python3 "$SEL/harness_cpp.py" build
      [ -x .perf_build/driver ] || { echo "run mode: no prebuilt C++ driver; run the build mode first" >&2; exit 2; }
      launch "$PWD/.perf_build/driver" "$BUDGET" "$IDX" ;;
    java)
      if [ "$MODE" = build ]; then
        rm -rf .perf_build && mkdir -p .perf_build \
          && javac -d .perf_build "$SEL/Harness.java" "$SEL/TreeNode.java" "$SEL/ListNode.java" solution.java >/dev/null 2>&1
        exit $?
      fi
      [ -f .perf_build/Harness.class ] || { echo "run mode: no prebuilt Java classes; run the build mode first" >&2; exit 2; }
      launch java -cp .perf_build Harness "$BUDGET" "$IDX" ;;
    csharp)
      if [ "$MODE" = build ]; then cs_build; exit $?; fi
      [ -f out/bench.dll ] || { echo "run mode: no prebuilt C# assembly; run the build mode first" >&2; exit 2; }
      launch dotnet out/bench.dll "$BUDGET" "$IDX" ;;
    *)
      echo "no build/run split for $LANG_ARG: not measured, because its run would include compilation" >&2
      exit 3 ;;
  esac
fi

case "$LANG_ARG" in
  python3)    python3 test_suite.py "$BUDGET" "$IDX" ;;            # cell already has the loop harness
  javascript) node "$SEL/harness.js" "$BUDGET" "$IDX" ;;
  typescript) node "$SEL/harness_ts.js" "$BUDGET" "$IDX" ;;
  php)        php -d memory_limit=2G "$SEL/harness.php" "$BUDGET" "$IDX" ;;   # match other langs (no 128M cap)
  ruby)       ruby "$SEL/harness.rb" "$BUDGET" "$IDX" ;;
  cpp)        python3 "$SEL/harness_cpp.py" "$BUDGET" "$IDX" ;;    # codegen driver-generator
  c)          python3 "$SEL/harness_c.py" "$BUDGET" "$IDX" ;;    # codegen driver-generator
  swift)      python3 "$SEL/harness_swift.py" "$BUDGET" "$IDX" ;; # native swiftc driver
  scala)      python3 "$SEL/harness_scala.py" "$BUDGET" "$IDX" ;; # JVM scalac driver
  rust)       python3 "$SEL/harness_rust.py" "$BUDGET" "$IDX" ;;
  dart)       python3 "$SEL/harness_dart.py" "$BUDGET" "$IDX" ;; # dart run (JIT) driver
  elixir)     elixir "$SEL/harness.exs" "$BUDGET" "$IDX" ;;       # BEAM, dynamic apply
  racket)     racket "$SEL/harness.rkt" "$BUDGET" "$IDX" ;;       # Racket VM, dynamic-require
  erlang)
    work="$(mktemp -d)"
    if erlc -I "$SEL" -o "$work" "$SEL/perf_harness.erl" solution.erl >/dev/null 2>&1; then
      erl -noshell -pa "$work" -eval "perf_harness:run(\"$BUDGET\", \"$IDX\")" -s init stop; rc=$?
    else
      echo "erlc failed for erlang" >&2; rc=2
    fi
    rm -rf "$work"; exit $rc ;;
  golang)     bash "$SEL/harness_go.sh" "$BUDGET" "$IDX" ;;
  java)
    cp "$SEL/Harness.java" "$SEL/TreeNode.java" "$SEL/ListNode.java" .
    javac Harness.java TreeNode.java ListNode.java solution.java >/dev/null 2>&1 && java Harness "$BUDGET" "$IDX"
    rc=$?; rm -f Harness.java TreeNode.java ListNode.java *.class; exit $rc ;;
  kotlin)
    cp "$SEL/Harness.java" "$SEL/TreeNode.java" "$SEL/ListNode.java" .
    # kotlinc cold-start (~30s) dominates, and the measure loop invokes this
    # ONCE PER CURATED CASE (x2 for energy+memory). Recompiling every time blows
    # the dispatch timeout, so compile ONCE per solution — keyed by content hash
    # — and reuse the classes. A fresh submission (new solution.kt) recompiles.
    h="$(cksum solution.kt 2>/dev/null | cut -d' ' -f1)"
    if [ ! -f .kt_built ] || [ "$(cat .kt_built 2>/dev/null)" != "$h" ] || [ ! -f Harness.class ]; then
      javac Harness.java TreeNode.java ListNode.java >/dev/null 2>&1 \
        && kotlinc solution.kt -cp . -d . >/dev/null 2>&1 \
        && printf '%s' "$h" > .kt_built
    fi
    kotlin -cp . Harness "$BUDGET" "$IDX"; rc=$?
    rm -f Harness.java TreeNode.java ListNode.java; exit $rc ;;
  csharp)
    cp "$SEL/Harness.cs" ./Harness.cs
    cat > bench.csproj <<'PROJ'
<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup>
<OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework>
<ImplicitUsings>enable</ImplicitUsings><Nullable>disable</Nullable>
<AssemblyName>bench</AssemblyName><EnableDefaultCompileItems>false</EnableDefaultCompileItems>
</PropertyGroup><ItemGroup><Compile Include="solution.cs"/><Compile Include="Harness.cs"/></ItemGroup></Project>
PROJ
    # `dotnet build` (~5-20s incl. restore) is invoked ONCE PER CURATED CASE by
    # the measure loop; recompiling every time blows the dispatch timeout. So
    # compile ONCE per solution (content-hash keyed) and reuse out/bench.dll.
    h="$(cksum solution.cs 2>/dev/null | cut -d' ' -f1)"
    if [ ! -f .cs_built ] || [ "$(cat .cs_built 2>/dev/null)" != "$h" ] || [ ! -f out/bench.dll ]; then
      dotnet build bench.csproj -c Release -o out --nologo -v quiet >/dev/null 2>&1 && printf '%s' "$h" > .cs_built
    fi
    dotnet out/bench.dll "$BUDGET" "$IDX"; rc=$?
    rm -f Harness.cs bench.csproj; rm -rf obj bin; exit $rc ;;
  *) echo "unknown lang $LANG_ARG" >&2; exit 2 ;;
esac
