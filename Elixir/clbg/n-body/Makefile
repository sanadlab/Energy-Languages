LANG        = Elixir
TEST        = n-body
SOURCE      = nbody.exs
OUTPUT      = n-body.exs_run
ARG         = 15000000
RUN_CMD     = elixir $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt

include ../../../perfarena.mk
