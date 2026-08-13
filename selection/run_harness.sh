#!/bin/bash
# Unified loop-harness runner: invoke ANY language's shared-input loop harness
# for one case, looped to a wall-time budget. Run FROM the cell directory
# (Energy-Languages/<LangDir>/leetcode/<slug>/). Prints the harness's
# CASE=/ITERS=/ACC=/BEACON= line to stderr; stdout stays empty.
#
#   run_harness.sh <arena_lang> <budget_seconds> <case_index>
#
# arena_lang: python3 cpp java csharp golang javascript typescript php ruby rust
set -o pipefail
LANG_ARG="$1"; BUDGET="${2:-1.0}"; IDX="${3:-0}"
SEL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$LANG_ARG" in
  python3)    python3 test_suite.py "$BUDGET" "$IDX" ;;            # cell already has the loop harness
  javascript) node "$SEL/harness.js" "$BUDGET" "$IDX" ;;
  typescript) node "$SEL/harness_ts.js" "$BUDGET" "$IDX" ;;
  php)        php -d memory_limit=2G "$SEL/harness.php" "$BUDGET" "$IDX" ;;   # match other langs (no 128M cap)
  ruby)       ruby "$SEL/harness.rb" "$BUDGET" "$IDX" ;;
  cpp)        python3 "$SEL/harness_cpp.py" "$BUDGET" "$IDX" ;;    # codegen driver-generator
  rust)       python3 "$SEL/harness_rust.py" "$BUDGET" "$IDX" ;;
  golang)     bash "$SEL/harness_go.sh" "$BUDGET" "$IDX" ;;
  java)
    cp "$SEL/Harness.java" ./Harness.java
    javac Harness.java solution.java >/dev/null 2>&1 && java Harness "$BUDGET" "$IDX"
    rc=$?; rm -f Harness.java *.class; exit $rc ;;
  csharp)
    cp "$SEL/Harness.cs" ./Harness.cs
    cat > bench.csproj <<'PROJ'
<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup>
<OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework>
<ImplicitUsings>enable</ImplicitUsings><Nullable>disable</Nullable>
<AssemblyName>bench</AssemblyName><EnableDefaultCompileItems>false</EnableDefaultCompileItems>
</PropertyGroup><ItemGroup><Compile Include="solution.cs"/><Compile Include="Harness.cs"/></ItemGroup></Project>
PROJ
    dotnet build bench.csproj -c Release -o out --nologo -v quiet >/dev/null 2>&1 && dotnet out/bench.dll "$BUDGET" "$IDX"
    rc=$?; rm -rf Harness.cs bench.csproj out obj bin; exit $rc ;;
  *) echo "unknown lang $LANG_ARG" >&2; exit 2 ;;
esac
