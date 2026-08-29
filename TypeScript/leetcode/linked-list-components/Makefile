# LC-energy linked-list-components (TypeScript) — CLBG-shape.
LANG        = TypeScript
TEST        = linked-list-components
SOURCE      = solution.ts
OUTPUT      = combined.js
ARG         =
RUN_CMD     = node combined.js
COMPILE_CMD = cat solution.ts test_suite.ts > combined.ts && tsc --target es2020 --module commonjs --strict false --skipLibCheck combined.ts

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

include ../../../perfarena.mk
