# LC-energy cousins-in-binary-tree (Go) — CLBG-shape.
LANG        = Go
TEST        = cousins-in-binary-tree
SOURCE      = solution.go
OUTPUT      = test_suite
ARG         =
RUN_CMD     = ./test_suite
COMPILE_CMD = { printf 'package main\n\n' ; grep -v '^package ' solution.go ; } > sol_combined.go && $(GO) build -o test_suite sol_combined.go test_suite.go

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

GO ?= go

include ../../../perfarena.mk
