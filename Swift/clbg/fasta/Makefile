LANG    = Swift
TEST    = fasta
SOURCE  = fasta.swift-3.swift
OUTPUT  = fasta.swift_run
ARG         = 12000000
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
