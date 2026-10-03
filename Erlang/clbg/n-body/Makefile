LANG    = Erlang
TEST    = n-body
SOURCE  = nbody.erl
MOD     = nbody
OUTPUT  = nbody.beam

ARG         = 15000000
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 1000
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/n-body.txt
include ../../../perfarena.mk
