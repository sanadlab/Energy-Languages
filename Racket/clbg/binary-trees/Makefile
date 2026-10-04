LANG        = Racket
TEST        = binary-trees
SOURCE      = binarytrees.rkt
OUTPUT      = compiled/binarytrees_rkt.zo
ARG         = 18
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
