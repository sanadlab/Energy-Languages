LANG    = Swift
TEST    = binary-trees
SOURCE  = binarytrees.swift-9.swift
OUTPUT  = binary-trees.swift_run
ARG         = 18
RUN_CMD = ./$(OUTPUT) $(ARG)

SWIFTC ?= swiftc
# apr comes from the system (Linux: libapr1-dev) or Homebrew (keg-only on macOS)
APR_INC ?= $(firstword $(wildcard /usr/include/apr-1.0 /usr/include/apr-1 \
             /opt/homebrew/opt/apr/include/apr-1 /usr/local/opt/apr/include/apr-1))
APR_FLAGS = $(if $(APR_INC),-Xcc -I$(APR_INC)) $(if $(findstring /opt/apr/,$(APR_INC)),-L$(APR_INC:/include/apr-1=/lib))
COMPILE_CMD = $(SWIFTC) -Ounchecked -wmo -I Include/apr $(APR_FLAGS) $(SOURCE) -o $(OUTPUT)

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
