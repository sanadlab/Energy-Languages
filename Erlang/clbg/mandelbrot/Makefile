LANG    = Erlang
TEST    = mandelbrot
SOURCE  = mandelbrot.erl
MOD     = mandelbrot
OUTPUT  = mandelbrot.beam

ARG         = 3504
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 200
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT    = 1
BINARY_TOLERANCE_BYTES = 16
include ../../../perfarena.mk
