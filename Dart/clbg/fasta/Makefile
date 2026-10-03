LANG    = Dart
TEST    = fasta
SOURCE  = fasta.dart
OUTPUT  = fasta.dart_run
ARG         = 12000000
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
