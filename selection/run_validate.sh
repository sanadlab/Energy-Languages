#!/bin/bash
# Full-suite correctness validator dispatch — the correctness half of the
# arena-local oracle. Run FROM the cell dir
# (Energy-Languages/<LangDir>/leetcode/<slug>/):
#
#   run_validate.sh <arena_lang>
#
# Runs the solution against EVERY reference case for the problem and compares
# each result to the expected output (reference/leetcode/outputs/<slug>.json).
# Prints one VALIDATE line to stderr. Exit codes:
#   0  Accepted        (every case matched)
#   1  Wrong Answer    (a case's output differed)
#   3  Runtime Error   (a case crashed)
#   2  not-yet-built for this language / setup error
set -o pipefail
LANG_ARG="$1"
SEL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$LANG_ARG" in
  python3)    python3 "$SEL/validate_suite.py" ;;
  javascript) node "$SEL/validate_suite.js" ;;
  ruby)       ruby "$SEL/validate_suite.rb" ;;
  php)        php "$SEL/validate_suite.php" ;;
  java)
    cp "$SEL/Harness.java" "$SEL/TreeNode.java" "$SEL/ListNode.java" .
    if javac Harness.java TreeNode.java ListNode.java solution.java >/tmp/leetval_javac.log 2>&1; then
      java Harness validate; rc=$?
    else
      echo "validate: javac failed for java" >&2; rc=2
    fi
    rm -f Harness.java TreeNode.java ListNode.java *.class; exit $rc ;;
  kotlin)
    cp "$SEL/Harness.java" "$SEL/TreeNode.java" "$SEL/ListNode.java" .
    if ! javac Harness.java TreeNode.java ListNode.java >/tmp/leetval_javac.log 2>&1; then
      echo "validate: javac harness failed for kotlin" >&2; rc=2
    elif ! kotlinc solution.kt -cp . -d . >/tmp/leetval_ktc.log 2>&1; then
      echo "validate: kotlinc failed for kotlin" >&2; rc=2
    else
      kotlin -cp . Harness validate; rc=$?
    fi
    rm -f Harness.java TreeNode.java ListNode.java *.class 2>/dev/null; rm -rf META-INF; exit $rc ;;
  typescript)
    # transpile solution.ts (types erased) then reuse the JS validator
    work="$(mktemp -d)"; cp solution.ts "$work/solution.ts"
    ( cd "$work" && tsc --target es2019 --module commonjs --strict false --skipLibCheck solution.ts ) >/dev/null 2>&1
    if [ ! -f "$work/solution.js" ]; then
      echo "validate: tsc produced no JS for typescript" >&2; rm -rf "$work"; exit 2
    fi
    VALIDATE_SOLUTION_FILE="$work/solution.js" node "$SEL/validate_suite.js"; rc=$?
    rm -rf "$work"; exit $rc ;;
  csharp)
    cp "$SEL/Harness.cs" ./Harness.cs
    cat > bench.csproj <<'PROJ'
<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup>
<OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework>
<ImplicitUsings>enable</ImplicitUsings><Nullable>disable</Nullable>
<AssemblyName>bench</AssemblyName><EnableDefaultCompileItems>false</EnableDefaultCompileItems>
</PropertyGroup><ItemGroup><Compile Include="solution.cs"/><Compile Include="Harness.cs"/></ItemGroup></Project>
PROJ
    if dotnet build bench.csproj -c Release -o out --nologo -v quiet >/tmp/leetval_dotnet.log 2>&1; then
      dotnet out/bench.dll validate; rc=$?
    else
      echo "validate: dotnet build failed for csharp" >&2; rc=2
    fi
    rm -rf Harness.cs bench.csproj out obj bin; exit $rc ;;
  golang)     bash "$SEL/harness_go.sh" validate ;;
  cpp)        python3 "$SEL/harness_cpp.py" validate ;;
  c)          python3 "$SEL/harness_c.py" validate ;;
  swift)      python3 "$SEL/harness_swift.py" validate ;;
  scala)      python3 "$SEL/harness_scala.py" validate ;;
  rust)       python3 "$SEL/harness_rust.py" validate ;;
  *) echo "validate: unknown lang $LANG_ARG" >&2; exit 2 ;;
esac
