# LC-energy cousins-in-binary-tree (TypeScript) — CLBG-shape.
LANG        = TypeScript
TEST        = cousins-in-binary-tree
SOURCE      = solution.ts
OUTPUT      = combined.js
ARG         =
RUN_CMD     = node combined.js
COMPILE_CMD = cat solution.ts test_suite.ts > combined.ts && node "$$(npm root -g)/typescript/lib/tsc.js" --target es2020 --module commonjs --strict false combined.ts

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

include ../../../perfarena.mk
