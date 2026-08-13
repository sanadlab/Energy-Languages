# LC-energy design-a-stack-with-increment-operation (Rust) — CLBG-shape.
# CustomStack is defined in solution.rs — no `pub struct Solution;`
# header needed. Just concatenate solution + test_suite.
LANG        = Rust
TEST        = design-a-stack-with-increment-operation
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
