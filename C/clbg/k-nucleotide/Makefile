# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = k-nucleotide
SOURCE      = knucleotide.c
OUTPUT      = k-nucleotide.gcc_run
ARG         = 0
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -std=c99 -IInclude $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-10000.txt

include ../../../perfarena.mk
