LANG    = Erlang
TEST    = mandelbrot
SOURCE  = mandelbrot.erl
MOD     = mandelbrot
OUTPUT  = mandelbrot.beam

ARG         = 3504
# no erl_crash.dump on a crash
RUN_CMD     = env ERL_CRASH_DUMP_BYTES=0 erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 200
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT    = 1
BINARY_TOLERANCE_BYTES = 16
include ../../../perfarena.mk
