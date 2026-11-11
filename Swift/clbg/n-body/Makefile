LANG    = Swift
TEST    = n-body
SOURCE  = nbody.swift-5.swift
OUTPUT  = n-body.swift_run
ARG         = 15000000
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt

include ../../../perfarena.mk
