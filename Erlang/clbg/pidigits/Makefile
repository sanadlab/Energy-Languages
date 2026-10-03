LANG    = Erlang
TEST    = pidigits
SOURCE  = pidigits.erl
MOD     = pidigits
OUTPUT  = pidigits.beam

ARG         = 10000
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 28
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/pidigits.txt
include ../../../perfarena.mk
