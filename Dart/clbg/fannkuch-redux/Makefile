LANG    = Dart
TEST    = fannkuch-redux
SOURCE  = fannkuchredux.dart-2.dart
OUTPUT  = fannkuch-redux.dart_run
ARG         = 11
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fannkuch-redux.txt

include ../../../perfarena.mk
