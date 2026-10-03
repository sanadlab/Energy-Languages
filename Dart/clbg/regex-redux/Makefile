LANG    = Dart
TEST    = regex-redux
SOURCE  = regexredux.dart-2.dart
OUTPUT  = regex-redux.dart_run
ARG         = 0
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-500000.txt

include ../../../perfarena.mk
