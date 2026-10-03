LANG        = Elixir
TEST        = spectral-norm
SOURCE      = spectralnorm.exs
OUTPUT      = spectral-norm.exs_run
ARG         = 4000
RUN_CMD     = elixir $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
