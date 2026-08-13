#!/bin/sh
# Generic Go loop-harness runner for the cross-language transfer check.
#
#   selection/harness_go.sh <budget_seconds> <case_index>
#   (run FROM the Go cell directory: Go/leetcode/<slug>/)
#
# Go cannot look up a top-level function by name at runtime, so we generate a
# tiny per-problem driver: package-strip solution.go into `package main`, splice
# the entry-point function name into harness_go.go.tmpl (a reflect-based generic
# loop), compile both into a throwaway binary, and run it. All artifacts live in
# a mktemp dir and are removed on exit; the cell is left clean. The binary prints
# CASE/ITERS/ACC/BEACON to STDERR and keeps STDOUT empty.
set -eu

BUDGET="${1:?usage: harness_go.sh <budget_seconds> <case_index>}"
IDX="${2:?usage: harness_go.sh <budget_seconds> <case_index>}"

CELL="$(pwd)"
SLUG="$(basename "$CELL")"
REF="$CELL/../../../reference/leetcode"
TMPL="$CELL/../../../selection/harness_go.go.tmpl"
GO="${GO:-go}"

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

BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

# 1) package-stripped solution -> package main (mirrors the Go cell Makefiles).
{ printf 'package main\n\n'; grep -v '^package ' "$CELL/solution.go"; } > "$BUILD/sol_combined.go"
# 2) generic harness with the entry-point function spliced in.
sed "s/__METHOD__/$METHOD/g" "$TMPL" > "$BUILD/zz_harness.go"

# Compile (build chatter -> stderr so the run's stdout stays empty).
if ! "$GO" build -o "$BUILD/hbin" "$BUILD/sol_combined.go" "$BUILD/zz_harness.go" 1>&2; then
  echo "ERR compile failed for $SLUG (method=$METHOD)" >&2
  exit 4
fi

# Run from the cell dir so the binary derives the slug and finds the inputs.
"$BUILD/hbin" "$BUDGET" "$IDX"
