# LC-energy linked-list-components (Rust) — CLBG-shape.
LANG        = Rust
TEST        = linked-list-components
SOURCE      = solution.rs
OUTPUT      = test_suite
ARG         =
RUN_CMD     = ./test_suite
COMPILE_CMD = { printf 'pub struct Solution;\n\n' ; cat test_suite.rs ; cat solution.rs ; } > _combined.rs && $(RUSTC) -O _combined.rs -o test_suite

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

RUSTC ?= rustc

include ../../../perfarena.mk
