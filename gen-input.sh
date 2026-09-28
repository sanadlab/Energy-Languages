#!/bin/bash
# Host-calibrated CLBG stdin MEASURE inputs.
#
# The three standard-input CLBG problems (reverse-complement, k-nucleotide,
# regex-redux) read a fasta stream. Their MEASURE workload is ONE shared fasta
# input per problem (identical bytes across every language), sized so the
# fastest measured language (C++) runs ~1s on the calibration host. Recalibrate
# when the measurement host changes.
#
# These files are LARGE and are NOT committed (see .gitignore); regenerate them
# once per host after checkout. Validation is DECOUPLED and does not need them:
# it uses the small committed fasta-1000..10000 via
# reference/clbg/outputs/<problem>/cases.txt.
#
# Calibrated sizes (C++ ~1s on bicho, Intel i7-7600U):
#   reverse-complement : fasta N=25,000,000  (~254 MB, C++ ~1.2s)
#   k-nucleotide       : fasta N=2,500,000   (~25 MB,  C++ ~1.3s)
#   regex-redux        : fasta N=500,000     (~5 MB,   C++ ~1.5s, Python ~1.2s)
set -euo pipefail
cd "$(dirname "$0")"
OUT=reference/clbg/inputs
mkdir -p "$OUT"

echo "Compiling the C++ fasta generator..."
make -s -C C++/clbg/fasta clean compile

declare -A SIZE=(
  [reverse-complement]=25000000
  [k-nucleotide]=2500000
  [regex-redux]=500000
)
for prob in reverse-complement k-nucleotide regex-redux; do
  N=${SIZE[$prob]}
  echo "Generating $OUT/fasta-$N.txt for $prob ..."
  make -s -C C++/clbg/fasta run ARG="$N" > "$OUT/fasta-$N.txt"
done
make -s -C C++/clbg/fasta clean
echo "Done. Measure inputs written to $OUT/ (fasta-25000000/2500000/500000.txt)."
