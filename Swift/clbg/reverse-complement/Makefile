LANG    = Swift
TEST    = reverse-complement
SOURCE  = revcomp.swift
OUTPUT  = reverse-complement.swift_run
ARG         = 0
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-25000000.txt

include ../../../perfarena.mk
