# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = pidigits
SOURCE      = pidigits.c
OUTPUT      = pidigits.gcc_run
ARG         = 10000
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native  $(SOURCE) -o $(OUTPUT) -lgmp

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt

include ../../../perfarena.mk
