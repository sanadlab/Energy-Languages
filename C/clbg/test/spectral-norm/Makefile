# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = spectral-norm
SOURCE      = spectralnorm.gcc-4.c
OUTPUT      = spectral-norm.gcc_run
ARG         = 4000
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -mfpmath=sse -msse2 $(SOURCE) -o $(OUTPUT) -lm

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/spectral-norm.txt

include ../../../../perfarena.mk
