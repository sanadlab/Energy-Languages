#!/bin/bash
# CLBG multi-case correctness oracle. Called by perfarena.mk's `validate` target
# when reference/clbg/outputs/<problem>/cases.txt exists.
#
#   clbg_validate.sh "<RUN_CMD>" "<ARG>" "<problem>" "<binary?0/1>"
#
# cases.txt has one case per line: an ARG value (arg-based problem) or
# `@<input-file>` (stdin-based). Each case i is compared to NN.out (byte-exact
# via cmp when binary, line-exact via diff otherwise). Exit 0 iff ALL cases pass.
set -o pipefail
RUN_CMD="$1"; ARG="$2"; PROB="$3"; BIN="$4"
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"        # Energy-Languages root
DIR="$BASE/reference/clbg/outputs/$PROB"
INDIR="$BASE/reference/clbg/inputs"
CASES="$DIR/cases.txt"
[ -f "$CASES" ] || { echo "clbg-validate: no cases for $PROB" >&2; exit 2; }

act="$(mktemp)"; err="$(mktemp)"
i=0; pass=0; total=0; firstfail=""
while IFS= read -r cv; do
  [ -z "$cv" ] && continue
  i=$((i + 1)); total=$((total + 1))
  ref="$DIR/$(printf '%02d' "$i").out"
  if [ "${cv#@}" != "$cv" ]; then                             # stdin case: `@<input>`
    eval "$RUN_CMD" < "$INDIR/${cv#@}" > "$act" 2>"$err"; rc=$?
  else                                                        # arg case: substitute ARG -> N
    cmd="$(printf '%s' "$RUN_CMD" | sed "s/[[:space:]]$ARG\$/ $cv/; s/[[:space:]]$ARG[[:space:]]/ $cv /")"
    eval "$cmd" > "$act" 2>"$err"; rc=$?
  fi
  if [ "$rc" -ne 0 ]; then
    [ -z "$firstfail" ] && firstfail="case $i (=$cv) crashed rc=$rc: $(tail -1 "$err" 2>/dev/null)"
    continue
  fi
  if [ "$BIN" = "1" ]; then cmp -s "$act" "$ref"; else diff -q "$act" "$ref" >/dev/null 2>&1; fi
  if [ $? -eq 0 ]; then
    pass=$((pass + 1))
  else
    [ -z "$firstfail" ] && firstfail="case $i (=$cv) output differs from $(basename "$ref")"
  fi
done < "$CASES"
rm -f "$act" "$err"

if [ "$pass" = "$total" ] && [ "$total" -gt 0 ]; then
  echo "CLBG-VALIDATE $PROB PASS passed=$pass ncases=$total" >&2; exit 0
fi
echo "CLBG-VALIDATE $PROB FAIL passed=$pass ncases=$total; $firstfail" >&2; exit 1
