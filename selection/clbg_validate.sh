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
# Per-case wall-clock cap. Validation cases are small, so a case that runs long
# is a hanging or pathologically slow solution — kill it fast (clean per-case
# fail) instead of letting it stall the whole validate until the handler's
# multi-minute watchdog fires as an opaque TimeoutExpired.
CASE_TO="${PERFARENA_VALIDATE_CASE_TIMEOUT_S:-20}"
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"        # Energy-Languages root
DIR="$BASE/reference/clbg/outputs/$PROB"
INDIR="$BASE/reference/clbg/inputs"
CASES="$DIR/cases.txt"
[ -f "$CASES" ] || { echo "clbg-validate: no cases for $PROB" >&2; exit 2; }

# Numeric tolerance for FLOAT-output problems. n-body and spectral-norm print a
# floating-point result to 9 decimals; a correct solution that does not
# reproduce the exact summation order of the reference differs in the last one
# or two digits, so an exact byte match rejects correct code. Compare those
# numerically within TOL instead. A per-problem `tolerance` file overrides the
# default. Empty TOL keeps the exact diff for every other problem.
TOL=""
if [ -f "$DIR/tolerance" ]; then
  TOL="$(tr -d '[:space:]' < "$DIR/tolerance")"
elif [ "$PROB" = "n-body" ] || [ "$PROB" = "spectral-norm" ]; then
  TOL="1e-6"
fi

# _num_eq <actual> <ref> <tol>: 0 iff the files match field-by-field, comparing
# numeric fields within <tol> and non-numeric fields exactly.
_num_eq() {
  awk -v tol="$3" '
    function isnum(x){ return (x ~ /^[+-]?([0-9]+\.?[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$/) }
    NR==FNR { a[FNR]=$0; na=FNR; next }
    { b[FNR]=$0; nb=FNR }
    END {
      if (na != nb) exit 1
      for (i=1;i<=na;i++) {
        n1=split(a[i],f1," "); n2=split(b[i],f2," ")
        if (n1!=n2) exit 1
        for (j=1;j<=n1;j++) {
          if (isnum(f1[j]) && isnum(f2[j])) {
            d=f1[j]-f2[j]; if (d<0) d=-d
            if (d>tol) exit 1
          } else if (f1[j]!=f2[j]) exit 1
        }
      }
      exit 0
    }' "$1" "$2"
}

act="$(mktemp)"; err="$(mktemp)"
i=0; pass=0; total=0; firstfail=""; fail_detail=""
fail_case=""; fail_exp_b64=""; fail_prod_b64=""
while IFS= read -r cv; do
  [ -z "$cv" ] && continue
  i=$((i + 1)); total=$((total + 1))
  ref="$DIR/$(printf '%02d' "$i").out"
  if [ "${cv#@}" != "$cv" ]; then                             # stdin case: `@<input>`
    timeout "$CASE_TO" bash -c "$RUN_CMD" < "$INDIR/${cv#@}" > "$act" 2>"$err"; rc=$?
  else                                                        # arg case: substitute ARG -> N
    cmd="$(printf '%s' "$RUN_CMD" | sed "s/[[:space:]]$ARG\$/ $cv/; s/[[:space:]]$ARG[[:space:]]/ $cv /")"
    timeout "$CASE_TO" bash -c "$cmd" > "$act" 2>"$err"; rc=$?
  fi
  if [ "$rc" -ne 0 ]; then
    if [ -z "$firstfail" ]; then
      if [ "$rc" = "124" ]; then
        firstfail="case $i (=$cv) timed out after ${CASE_TO}s (hanging or too slow)"
      else
        firstfail="case $i (=$cv) crashed rc=$rc: $(tail -1 "$err" 2>/dev/null)"
      fi
      fail_detail="$(printf '=== stderr (case %s, first 4000 bytes) ===\n%s' "$i" "$(head -c 4000 "$err" 2>/dev/null)")"
    fi
    continue
  fi
  if [ "$BIN" = "1" ]; then
    cmp -s "$act" "$ref"
  elif [ -n "$TOL" ]; then
    _num_eq "$act" "$ref" "$TOL"
  else
    diff -q "$act" "$ref" >/dev/null 2>&1
  fi
  if [ $? -eq 0 ]; then
    pass=$((pass + 1))
  elif [ -z "$firstfail" ]; then
    firstfail="case $i (=$cv) output differs from $(basename "$ref")"
    # Capture a truncated expected-vs-produced diff so the platform and webapp
    # can show WHY validation failed, not just that it did.
    if [ "$BIN" = "1" ]; then
      fail_detail="$(printf '=== binary output differs (case %s): %s ===\n--- expected %s (hex, head) ---\n%s\n--- produced (hex, head) ---\n%s' \
        "$i" "$(cmp "$ref" "$act" 2>&1 | head -1)" "$(basename "$ref")" \
        "$(xxd "$ref" 2>/dev/null | head -12)" "$(xxd "$act" 2>/dev/null | head -12)")"
    else
      fail_detail="$(diff -u --label "expected ($(basename "$ref"))" --label "produced" "$ref" "$act" 2>/dev/null | head -c 4000)"
      # Machine-parseable expected/produced (base64, truncated) so the handler
      # can populate the SPA's side-by-side panel. Text problems only; binary
      # outputs keep the hex diff above.
      fail_case="case $i (=$cv)"
      fail_exp_b64="$(head -c 4000 "$ref" 2>/dev/null | base64 | tr -d '\n')"
      fail_prod_b64="$(head -c 4000 "$act" 2>/dev/null | base64 | tr -d '\n')"
    fi
  fi
done < "$CASES"
rm -f "$act" "$err"

if [ "$pass" = "$total" ] && [ "$total" -gt 0 ]; then
  echo "CLBG-VALIDATE $PROB PASS passed=$pass ncases=$total" >&2; exit 0
fi
echo "CLBG-VALIDATE $PROB FAIL passed=$pass ncases=$total; $firstfail" >&2
[ -n "$fail_detail" ] && printf '%s\n' "$fail_detail" >&2
if [ -n "$fail_exp_b64" ]; then
  printf 'PERFARENA-DIFF-CASE:%s\n' "$fail_case" >&2
  printf 'PERFARENA-DIFF-EXPECTED-B64:%s\n' "$fail_exp_b64" >&2
  printf 'PERFARENA-DIFF-PRODUCED-B64:%s\n' "$fail_prod_b64" >&2
fi
exit 1
