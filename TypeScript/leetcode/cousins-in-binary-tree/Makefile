# LC-energy cousins-in-binary-tree (TypeScript) — CLBG-shape.
LANG        = TypeScript
TEST        = cousins-in-binary-tree
SOURCE      = solution.ts
OUTPUT      = combined.js
ARG         =
RUN_CMD     = node combined.js
COMPILE_CMD = cat solution.ts test_suite.ts > combined.ts && tsc --target es2020 --module commonjs --strict false --skipLibCheck combined.ts

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

include ../../../perfarena.mk
