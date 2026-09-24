# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = fannkuch-redux
SOURCE      = fannkuchredux.gcc-5.c
OUTPUT      = fannkuch-redux.gcc_run
ARG         = 11
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 -fopenmp $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/fannkuch-redux.txt

include ../../../../perfarena.mk
