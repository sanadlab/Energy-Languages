LANG    = Erlang
TEST    = reverse-complement
SOURCE  = revcomp.erl
MOD     = revcomp
OUTPUT  = revcomp.beam

ARG         = 0
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

STDIN_FILE       = ../../../reference/clbg/inputs/fasta-25000000.txt
VALIDATION_N     = 0
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/reverse-complement.txt
include ../../../perfarena.mk
