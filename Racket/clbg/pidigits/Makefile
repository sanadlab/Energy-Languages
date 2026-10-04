LANG        = Racket
TEST        = pidigits
SOURCE      = pidigits.rkt
OUTPUT      = compiled/pidigits_rkt.zo
ARG         = 10000
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt

include ../../../perfarena.mk
