# LC-energy finding-mk-average (Rust) — CLBG-shape.
# MKAverage is defined in solution.rs — no `pub struct Solution;`
# header needed.
LANG        = Rust
TEST        = finding-mk-average
SOURCE      = solution.rs
OUTPUT      = test_suite
ARG         =
RUN_CMD     = ./test_suite
COMPILE_CMD = cat solution.rs test_suite.rs > _combined.rs && $(RUSTC) -O _combined.rs -o test_suite

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

RUSTC ?= rustc

include ../../../perfarena.mk
