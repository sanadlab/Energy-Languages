LANG        = Racket
TEST        = reverse-complement
SOURCE      = revcomp.rkt
OUTPUT      = compiled/revcomp_rkt.zo
ARG         = 0
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-25000000.txt

include ../../../perfarena.mk
