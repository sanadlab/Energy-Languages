LANG    = Dart
TEST    = binary-trees
SOURCE  = binarytrees.dart
OUTPUT  = binary-trees.dart_run
ARG         = 18
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
