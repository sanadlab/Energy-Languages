LANG        = TypeScript
TEST        = k-nucleotide
SOURCE      = knucleotide.ts
OUTPUT      = k-nucleotide.js
ARG         = 21
RUN_CMD     = node $(OUTPUT) $(ARG)

TSC ?= tsc

COMPILE_CMD = $(TSC) --target es2020 --outFile $(OUTPUT) $(SOURCE)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-10000.txt

include ../../../perfarena.mk
