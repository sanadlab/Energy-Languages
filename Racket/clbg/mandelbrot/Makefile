LANG        = Racket
TEST        = mandelbrot
SOURCE      = mandelbrot.rkt
OUTPUT      = compiled/mandelbrot_rkt.zo
ARG         = 3504
RUN_CMD     = racket $(SOURCE) $(ARG)
COMPILE_CMD = raco make $(SOURCE)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot/java.pbm
BINARY_OUTPUT      = 1

include ../../../perfarena.mk
