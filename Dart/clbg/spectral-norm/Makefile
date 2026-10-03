LANG    = Dart
TEST    = spectral-norm
SOURCE  = spectralnorm.dart
OUTPUT  = spectral-norm.dart_run
ARG         = 4000
RUN_CMD = ./$(OUTPUT) $(ARG)

DART ?= dart
COMPILE_CMD = $(DART) compile exe $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
