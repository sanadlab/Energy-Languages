LANG    = Swift
TEST    = pidigits
SOURCE  = pidigits.swift-2.swift
OUTPUT  = pidigits.swift_run
ARG         = 10000
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
# gmp comes from the system (Linux: libgmp-dev) or Homebrew on macOS
GMP_PREFIX ?= $(firstword $(foreach p,/opt/homebrew /usr/local,$(if $(wildcard $(p)/include/gmp.h),$(p))))
GMP_FLAGS = $(if $(GMP_PREFIX),-Xcc -I$(GMP_PREFIX)/include -L$(GMP_PREFIX)/lib)
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo -I Include/gmp $(GMP_FLAGS) $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt

include ../../../perfarena.mk
