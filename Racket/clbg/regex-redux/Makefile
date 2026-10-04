LANG        = Racket
TEST        = regex-redux
SOURCE      = regexredux.rkt
OUTPUT      = compiled/regexredux_rkt.zo
ARG         = 0
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-500000.txt

include ../../../perfarena.mk
