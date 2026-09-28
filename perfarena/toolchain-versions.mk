# Toolchain versions for the PerfArena harness cells -- single source of truth.
#
# Included by perfarena.mk (resolved relative to it, so it works from any cell
# depth). Change a version here once instead of in every cell Makefile. Any
# value can still be overridden per-invocation with an env var or
# `make VAR=... target`.
#
#   TS_VERSION   TypeScript compiler version for transpiling TypeScript cells.
#                Needs >= 5.6 for the `--noCheck` transpile-only flag.
TS_VERSION ?= 5.9.3
