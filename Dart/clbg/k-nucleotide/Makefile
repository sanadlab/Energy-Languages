LANG    = Dart
TEST    = k-nucleotide
SOURCE  = knucleotide.dart-2.dart
OUTPUT  = k-nucleotide.dart_run
ARG         = 0
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-2500000.txt

include ../../../perfarena.mk
