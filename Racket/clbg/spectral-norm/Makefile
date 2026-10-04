LANG        = Racket
TEST        = spectral-norm
SOURCE      = spectralnorm.rkt
OUTPUT      = compiled/spectralnorm_rkt.zo
ARG         = 4000
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
