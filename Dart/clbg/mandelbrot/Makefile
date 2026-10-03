LANG    = Dart
TEST    = mandelbrot
SOURCE  = mandelbrot.dart
OUTPUT  = mandelbrot.dart_run
ARG         = 3504
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot/dart.pbm
BINARY_OUTPUT      = 1

include ../../../perfarena.mk
