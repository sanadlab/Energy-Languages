#!/bin/bash
# Reference-solution smoke test for the deployed oracle.
#
# Runs `make -s clean compile validate` on every isolated reference cell
# (<Lang>/clbg/test/<problem>/) and reports PASS/FAIL per (language, problem).
# Green = the oracle can compile, run, and validate the reference solution.
# A FAIL means the harness/toolchain is broken for that cell, not the model.
#
#   selection/run_reference_tests.sh [Lang ...]     # default: all languages
#
# Exit code: 0 iff every reference cell passes.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Match the harness toolchain PATH so cargo/dotnet/etc. resolve.
export PATH="$HOME/.cargo/bin:$HOME/.dotnet:$PATH"
PER_CELL_TIMEOUT="${PERFARENA_REF_TEST_TIMEOUT_S:-300}"

langs=("$@")
if [ "${#langs[@]}" -eq 0 ]; then
  mapfile -t langs < <(cd "$ROOT" && for d in */clbg/test; do [ -d "$d" ] && dirname "$(dirname "$d")"; done)
fi

pass=0; fail=0; failed_cells=()
printf '%-12s %-18s %-8s %s\n' LANG PROBLEM RESULT DETAIL
printf '%s\n' "--------------------------------------------------------------------"
for lang in "${langs[@]}"; do
  tdir="$ROOT/$lang/clbg/test"
  [ -d "$tdir" ] || continue
  for cell in "$tdir"/*/; do
    [ -d "$cell" ] || continue
    prob="$(basename "$cell")"
    out="$(cd "$cell" && timeout "$PER_CELL_TIMEOUT" make -s clean compile validate 2>&1)"
    rc=$?
    if [ "$rc" -eq 0 ]; then
      pass=$((pass+1)); printf '%-12s %-18s %-8s\n' "$lang" "$prob" PASS
    else
      fail=$((fail+1)); failed_cells+=("$lang/$prob")
      # first meaningful error line
      detail="$(printf '%s' "$out" | grep -iE 'error|CLBG-VALIDATE .* FAIL|validate: FAIL|Cannot find|Exception|Traceback|make: \*\*\*' | head -1 | cut -c1-90)"
      [ -z "$detail" ] && detail="$(printf '%s' "$out" | tail -1 | cut -c1-90)"
      [ "$rc" -eq 124 ] && detail="TIMEOUT after ${PER_CELL_TIMEOUT}s"
      printf '%-12s %-18s %-8s %s\n' "$lang" "$prob" FAIL "$detail"
    fi
    (cd "$cell" && make -s clean >/dev/null 2>&1)
  done
done
printf '%s\n' "--------------------------------------------------------------------"
printf 'PASS=%d FAIL=%d\n' "$pass" "$fail"
[ "$fail" -gt 0 ] && { printf 'failed: %s\n' "${failed_cells[*]}"; exit 1; }
exit 0
