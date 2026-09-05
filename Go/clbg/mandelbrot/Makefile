LANG    = Go
TEST    = mandelbrot
SOURCE  = mandelbrot.go-3.go
OUTPUT  = mandelbrot.go_run
ARG         = 7000
RUN_CMD = ./$(OUTPUT) $(ARG)

COMPILE_CMD = go build -o $(OUTPUT) $(SOURCE)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot/go.pbm
BINARY_OUTPUT      = 1

include ../../../perfarena.mk
