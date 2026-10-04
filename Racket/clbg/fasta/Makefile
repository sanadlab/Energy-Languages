LANG        = Racket
TEST        = fasta
SOURCE      = fasta.rkt
OUTPUT      = compiled/fasta_rkt.zo
ARG         = 12000000
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
