# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = binary-trees
SOURCE      = binarytrees.gcc-3.c
OUTPUT      = binary-trees.gcc_run
ARG         = 18
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -D_FILE_OFFSET_BITS=64 -I/usr/include/apr-1.0 $(SOURCE) -o $(OUTPUT) -lapr-1 -lgomp -lm

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/binary-trees.txt

include ../../../../perfarena.mk
