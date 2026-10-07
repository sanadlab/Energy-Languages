LANG    = Go
TEST    = mandelbrot
SOURCE  = mandelbrot.go-3.go
OUTPUT  = mandelbrot.go_run
ARG         = 3504
RUN_CMD = ./$(OUTPUT) $(ARG)

COMPILE_CMD = go build -o $(OUTPUT) $(SOURCE)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT      = 1
BINARY_TOLERANCE_BYTES = 16

include ../../../perfarena.mk
