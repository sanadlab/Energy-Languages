LANG    = Swift
TEST    = spectral-norm
SOURCE  = spectralnorm.swift-3.swift
OUTPUT  = spectral-norm.swift_run
ARG         = 4000
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
