LANG    = Swift
TEST    = k-nucleotide
SOURCE  = knucleotide.swift-2.swift
OUTPUT  = k-nucleotide.swift_run
ARG         = 0
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-2500000.txt

include ../../../perfarena.mk
