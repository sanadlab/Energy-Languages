LANG        = Racket
TEST        = fannkuch-redux
SOURCE      = fannkuchredux.rkt
OUTPUT      = compiled/fannkuchredux_rkt.zo
ARG         = 11
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fannkuch-redux.txt

include ../../../perfarena.mk
