# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = fasta
SOURCE      = fasta.gcc-2.c
OUTPUT      = fasta.gcc_run
ARG         = 12000000
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 -mfpmath=sse -msse3 -fopenmp $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
