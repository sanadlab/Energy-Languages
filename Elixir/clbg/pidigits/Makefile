LANG        = Elixir
TEST        = pidigits
SOURCE      = pidigits.exs
OUTPUT      = pidigits.exs_run
ARG         = 10000
RUN_CMD     = elixir $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt

include ../../../perfarena.mk
