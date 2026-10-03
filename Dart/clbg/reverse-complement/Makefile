LANG    = Dart
TEST    = reverse-complement
SOURCE  = revcomp.dart-3.dart
OUTPUT  = reverse-complement.dart_run
ARG         = 0
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-25000000.txt

include ../../../perfarena.mk
