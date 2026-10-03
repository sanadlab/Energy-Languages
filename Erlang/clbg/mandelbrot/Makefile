LANG    = Erlang
TEST    = mandelbrot
SOURCE  = mandelbrot.erl
MOD     = mandelbrot
OUTPUT  = mandelbrot.beam

ARG         = 3504
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 200
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/mandelbrot/java.pbm
BINARY_OUTPUT    = 1
include ../../../perfarena.mk
