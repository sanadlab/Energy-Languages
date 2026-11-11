#!/bin/sh
# Generic Go loop-harness runner. Run FROM the Go cell directory
# (Go/leetcode/<slug>/):
#
#   harness_go.sh <budget_seconds> <case_index>   build in a temp dir, then run one case
#   harness_go.sh validate                         build, then check every reference case
#   harness_go.sh build                            build once into .perf_build/driver; runs nothing
#   harness_go.sh compile                          build and discard (the cell's `make compile`)
#
# Go cannot look up a top-level function by name at runtime, so we generate a
# tiny per-problem driver: package-strip solution.go into `package main`, splice
# the entry-point function name into harness_go.go.tmpl (a reflect-based generic
# loop), and compile both into one binary. The build runs in a temp dir inside
# the module selection/go_lc_deps (go.mod + go.sum), so a solution can import
# github.com/emirpasic/gods, as on LeetCode. The first build that imports gods
# downloads the module into the Go module cache (network) when it is not there.
# The binary prints CASE/ITERS/ACC/BEACON to STDERR and keeps STDOUT empty.
#
# Exit codes: 2 when the code does not compile (Compile Error); in validate
# mode 0/1/3 from the binary, and 3 for any other crash after a successful
# build (a Go fatal error such as a stack overflow or a deadlock exits 2).
set -eu

MODE="${1:?usage: harness_go.sh <budget_seconds> <case_index> | validate | build | compile}"
case "$MODE" in
  validate|build|compile) ;;
  *) BUDGET="$MODE"; IDX="${2:?usage: harness_go.sh <budget_seconds> <case_index>}"; MODE=measure ;;
esac

CELL="$(pwd)"
SLUG="$(basename "$CELL")"
SEL="$(cd "$(dirname "$0")" && pwd)"
REF="$CELL/../../../reference/leetcode"
TMPL="$SEL/harness_go.go.tmpl"
DEPS="$SEL/go_lc_deps"
GO="${GO:-go}"
# Build with the installed Go only: go.mod says `go 1.23` (LeetCode's Go), and
# GOTOOLCHAIN=auto would download another toolchain on an older install.
export GOTOOLCHAIN=local

if [ ! -f "$CELL/solution.go" ]; then
  echo "ERR no solution.go in $CELL" >&2
  exit 2
fi
if [ ! -f "$TMPL" ]; then
  echo "ERR missing template $TMPL" >&2
  exit 2
fi

# Entry point spliced into the template as __METHOD__.
#  * design classes (a `func Constructor(...)` factory) -> splice Constructor;
#    the driver replays ops/args against it and ignores the workload entry_point
#    (which names an instance method Go can't reference as a top-level symbol).
#  * everything else -> the workload entry_point's last '.'-token, the Go
#    top-level function to reflect-call (plain data, or a *TreeNode/*ListNode).
if grep -qE '^[[:space:]]*func[[:space:]]+Constructor[[:space:]]*\(' "$CELL/solution.go"; then
  METHOD="Constructor"
else
  METHOD="$(python3 -c "import json;print(json.load(open('$REF/workloads/$SLUG.json'))['entry_point'].split('.')[-1].replace('()',''))")"
fi
if [ -z "$METHOD" ]; then
  echo "ERR could not derive entry-point method for $SLUG" >&2
  exit 2
fi

# LeetCode declares TreeNode / ListNode only for the problems whose starter
# code uses them (the snippet's definition comment). For the other problems
# the harness renames its own copies, so a solution's own type of that name
# compiles.
NODES=""
grep -qE 'type[[:space:]]+TreeNode[[:space:]]+struct' "$CELL/problem.json" 2>/dev/null \
  || NODES="${NODES}s/TreeNode/hzTreeNode/g;"
grep -qE 'type[[:space:]]+ListNode[[:space:]]+struct' "$CELL/problem.json" 2>/dev/null \
  || NODES="${NODES}s/ListNode/hzListNode/g;"

BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

# 1) solution -> package main. A `package` line becomes an empty line and the
#    //line directive keeps the compiler's line numbers those of solution.go.
{ printf 'package main\n\n//line solution.go:1:1\n'; sed 's/^package .*//' "$CELL/solution.go"; } > "$BUILD/sol_combined.go"
# 2) generic harness with the entry-point function spliced in (after the
#    renames, so an entry point such as validateBinaryTreeNodes stays intact).
sed "${NODES}s/__METHOD__/$METHOD/g" "$TMPL" > "$BUILD/zz_harness.go"
# 3) the module: gods is the one third-party package LeetCode's Go offers.
cp "$DEPS/go.mod" "$DEPS/go.sum" "$BUILD/"

# Compile (build chatter -> stderr so the run's stdout stays empty).
if ! (cd "$BUILD" && "$GO" build -o hbin .) 1>&2; then
  echo "ERR compile failed for $SLUG (method=$METHOD)" >&2
  exit 2
fi

case "$MODE" in
  compile) exit 0 ;;
  build)
    # copy, then rename: overwriting an executable in place makes macOS kill
    # its next start (SIGKILL); a rename gives a new file
    mkdir -p "$CELL/.perf_build"
    cp "$BUILD/hbin" "$CELL/.perf_build/driver.new"
    mv -f "$CELL/.perf_build/driver.new" "$CELL/.perf_build/driver"
    exit 0 ;;
  validate)
    # Run from the cell dir so the binary derives the slug and finds the inputs.
    # The binary writes the case it is on to HZ_PROGRESS, so a crash it cannot
    # report itself (a Go fatal error exits 2, a signal kills it) still names
    # the case.
    rc=0
    HZ_PROGRESS="$BUILD/progress" "$BUILD/hbin" validate || rc=$?
    case "$rc" in 0|1|3) exit "$rc" ;; esac
    echo "VALIDATE slug=$SLUG RE $(cat "$BUILD/progress" 2>/dev/null || echo 'case=? passed=0') exit=$rc" >&2
    exit 3 ;;
  measure)
    "$BUILD/hbin" "$BUDGET" "$IDX" ;;
esac
