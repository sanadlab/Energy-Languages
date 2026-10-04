LANG        = Racket
TEST        = k-nucleotide
SOURCE      = knucleotide.rkt
OUTPUT      = compiled/knucleotide_rkt.zo
ARG         = 0
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-2500000.txt

include ../../../perfarena.mk
