LANG    = Erlang
TEST    = binary-trees
SOURCE  = binarytrees.erl
MOD     = binarytrees
OUTPUT  = binarytrees.beam

ARG         = 18
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 10
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/binary-trees.txt
include ../../../perfarena.mk
