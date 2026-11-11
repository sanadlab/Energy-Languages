LANG    = Swift
TEST    = regex-redux
SOURCE  = regexredux.swift-2.swift
OUTPUT  = regex-redux.swift_run
ARG         = 0
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-500000.txt

include ../../../perfarena.mk
