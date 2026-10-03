LANG    = Erlang
TEST    = fasta
SOURCE  = fasta.erl
MOD     = fasta
OUTPUT  = fasta.beam

ARG         = 12000000
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 1000
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/fasta.txt
include ../../../perfarena.mk
