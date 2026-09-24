# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = n-body
SOURCE      = nbody.gcc-4.c
OUTPUT      = n-body.gcc_run
ARG         = 15000000
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 $(SOURCE) -o $(OUTPUT) -lm

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt

include ../../../perfarena.mk
