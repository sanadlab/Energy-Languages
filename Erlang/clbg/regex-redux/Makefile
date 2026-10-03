LANG    = Erlang
TEST    = regex-redux
SOURCE  = regexredux.erl
MOD     = regexredux
OUTPUT  = regexredux.beam

ARG         = 0
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

STDIN_FILE       = ../../../reference/clbg/inputs/fasta-500000.txt
VALIDATION_N     = 0
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/regex-redux.txt
include ../../../perfarena.mk
