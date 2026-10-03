LANG        = Elixir
TEST        = reverse-complement
SOURCE      = revcomp.exs
OUTPUT      = reverse-complement.exs_run
ARG         = 0
RUN_CMD     = elixir $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-25000000.txt

include ../../../perfarena.mk
