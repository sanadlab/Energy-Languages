LANG    = Dart
TEST    = n-body
SOURCE  = nbody.dart-3.dart
OUTPUT  = n-body.dart_run
ARG         = 15000000
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt

include ../../../perfarena.mk
