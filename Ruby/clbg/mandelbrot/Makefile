LANG        = Ruby
TEST        = mandelbrot
SOURCE      = mandelbrot.yarv-5.yarv
OUTPUT      = mandelbrot.rb
ARG         = 3504
RUN_CMD     = ruby $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT      = 1
BINARY_TOLERANCE_BYTES = 16

include ../../../perfarena.mk
