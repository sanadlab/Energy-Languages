LANG    = Erlang
TEST    = binary-trees
SOURCE  = binarytrees.erl
MOD     = binarytrees
OUTPUT  = binarytrees.beam

ARG         = 18
# no erl_crash.dump on a crash
RUN_CMD     = env ERL_CRASH_DUMP_BYTES=0 erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 10
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/binary-trees.txt
include ../../../perfarena.mk
