LANG    = Erlang
TEST    = fannkuch-redux
SOURCE  = fannkuchredux.erl
MOD     = fannkuchredux
OUTPUT  = fannkuchredux.beam

ARG         = 11
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 7
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/fannkuch-redux.txt
include ../../../perfarena.mk
