LANG    = Erlang
TEST    = k-nucleotide
SOURCE  = knucleotide.erl
MOD     = knucleotide
OUTPUT  = knucleotide.beam

ARG         = 0
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

STDIN_FILE       = ../../../reference/clbg/inputs/fasta-2500000.txt
VALIDATION_N     = 0
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/k-nucleotide.txt
include ../../../perfarena.mk
