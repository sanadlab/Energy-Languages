LANG    = Swift
TEST    = fannkuch-redux
SOURCE  = fannkuchredux.swift-3.swift
OUTPUT  = fannkuch-redux.swift_run
ARG         = 11
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fannkuch-redux.txt

include ../../../perfarena.mk
