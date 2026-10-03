LANG        = Elixir
TEST        = k-nucleotide
SOURCE      = knucleotide.exs
OUTPUT      = k-nucleotide.exs_run
ARG         = 0
RUN_CMD     = elixir $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-2500000.txt

include ../../../perfarena.mk
