LANG    = Dart
TEST    = pidigits
SOURCE  = pidigits.dart
OUTPUT  = pidigits.dart_run
ARG         = 10000
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt

include ../../../perfarena.mk
