LANG        = Elixir
TEST        = fasta
SOURCE      = fasta.exs
OUTPUT      = fasta.exs_run
ARG         = 12000000
RUN_CMD     = elixir $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
