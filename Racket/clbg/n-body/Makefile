LANG        = Racket
TEST        = n-body
SOURCE      = nbody.rkt
OUTPUT      = compiled/nbody_rkt.zo
ARG         = 15000000
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt

include ../../../perfarena.mk
