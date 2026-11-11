LANG        = Racket
TEST        = mandelbrot
SOURCE      = mandelbrot.rkt
OUTPUT      = .perf_build/compiled/mandelbrot_rkt.zo
ARG         = 3504
RUN_CMD     = racket .perf_build/$(SOURCE) $(ARG)
# The build compiles a copy of SOURCE in .perf_build/, so that a later rewrite
# or restore of SOURCE (the handler does both) neither makes the .zo look out of
# date (Racket would then compile again in memory on every run) nor lets the
# .zo of other code run for SOURCE.
COMPILE_CMD = rm -rf .perf_build && mkdir -p .perf_build && cp $(SOURCE) .perf_build/ && raco make .perf_build/$(SOURCE)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT      = 1
BINARY_TOLERANCE_BYTES = 16

include ../../../perfarena.mk
