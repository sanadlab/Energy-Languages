# Converted from the raw upstream C Makefile to the perfarena harness.
# ARG/VALIDATION_N/golden mirror the C++ cell; compile line from upstream C.
LANG        = C
TEST        = mandelbrot
SOURCE      = mandelbrot.gcc-6.c
OUTPUT      = mandelbrot.gcc_run
ARG         = 3504
RUN_CMD     = ./$(OUTPUT) $(ARG)

CC          ?= gcc

COMPILE_CMD = $(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -mno-fma -fno-finite-math-only -mfpmath=sse -msse2 -fopenmp $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/mandelbrot/cpp.pbm
BINARY_OUTPUT      = 1

include ../../../../perfarena.mk
