# perfarena.mk
#
# Common include for PerfArena benchmark Makefiles.
#
# Each per-benchmark Makefile sets a small number of variables
# describing the cell, then includes this file. See GUIDE.md for
# the full list of variables and what they mean.
#
# Variables:
#
#   LANG            Language folder name (Python, C++, Java, ...).
#   TEST            CLBG problem key (binary-trees, n-body, ...).
#   SOURCE          Canonical source file in this cell.
#   OUTPUT          Artifact produced by `make compile`.
#   ARG             Default N argument for measurement runs.
#   RUN_CMD         Command to invoke the benchmark at the default N.
#   COMPILE_CMD     Command to produce OUTPUT from SOURCE.
#
# Stdin-input problems (k-nucleotide, regex-redux, reverse-complement)
# also set:
#
#   STDIN_FILE      Path to the pre-generated input file (relative
#                   to the cell, typically ../../reference/inputs/...).
#
# When STDIN_FILE is set, the run/measure/validate targets pipe it
# into the benchmark automatically, so the harness and RAPL runner
# see a uniform command regardless of whether the problem reads
# from argv or stdin.
#
# Validation:
#
#   VALIDATION_N    Small N for the correctness check (runs in <1 s).
#   REFERENCE_OUTPUT  Path to the expected output at VALIDATION_N.
#   BINARY_OUTPUT   Set to 1 for mandelbrot (cmp instead of diff).
#
# The harness exports CC, CXX, CARGO_BUILD_TARGET, GOOS, GOARCH
# when cross-compiling. Per-language COMPILE_CMDs should use $(CC),
# $(CXX), etc. rather than hardcoded paths.

# .NET formats floating-point with the CURRENT culture, so on a comma-decimal
# host (or macOS, which ignores LC_NUMERIC) C# benchmarks emit "-0,169..." and
# fail validation against the "-0.169..." reference. Force the invariant culture
# so C# output is deterministic across hosts. Harmless for non-.NET languages.
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1

PERFARENA_WARMUP  ?= 10
PERFARENA_MEASURE ?= 20
PERFARENA_IDLE_S  ?= 5

# Energy-measurement runner selection.
#
# Three backends are supported. Every backend emits the same JSONL row
# schema (see perfarena/runners/*.py::_write_row) so downstream ingest
# doesn't need to care which one produced a row — the row's
# `energy_source` field tells you.
#
#   rapl          Direct MSR read via RAPL/perfarena_runner (Linux
#                 x86 only; requires the C binary built and sudo).
#                 Highest fidelity — 10 Hz counter, no daemon in
#                 the way.
#   codecarbon    Python wrapper via `perfarena.runners.codecarbon_runner`.
#                 Uses CodeCarbon which calls RAPL on Linux and
#                 powermetrics on macOS (with fallback to TDP est).
#                 Works everywhere codecarbon does.
#   powermetrics  Direct `powermetrics` sampling on macOS via
#                 `perfarena.runners.powermetrics_runner`. Sidesteps
#                 CodeCarbon's overhead + calibration issues. Needs
#                 sudo. Apple Silicon or Intel Mac.
#
# Selection precedence:
#   1. Explicit PERFARENA_RUNNER=... (advanced — set a full command).
#   2. PERFARENA_PROFILER=rapl|codecarbon|powermetrics (kind selector).
#   3. Auto: rapl on Linux with the binary built, powermetrics on
#      Darwin, codecarbon as universal fallback.
_RAPL_RUNNER          = ../../../RAPL/perfarena_runner
_CC_RUNNER            = python3 -m perfarena.runners.codecarbon_runner
_POWERMETRICS_RUNNER  = python3 -m perfarena.runners.powermetrics_runner

PERFARENA_PROFILER ?= auto

ifeq ($(PERFARENA_PROFILER),rapl)
  PERFARENA_RUNNER ?= $(_RAPL_RUNNER)
else ifeq ($(PERFARENA_PROFILER),codecarbon)
  PERFARENA_RUNNER ?= $(_CC_RUNNER)
else ifeq ($(PERFARENA_PROFILER),powermetrics)
  PERFARENA_RUNNER ?= $(_POWERMETRICS_RUNNER)
else
  # auto: prefer OS-native (rapl on Linux, powermetrics on Darwin),
  # fall back to codecarbon for portability. Users on Linux without
  # RAPL built get codecarbon; users on macOS without sudo get
  # codecarbon (which internally does TDP estimation).
  ifeq ($(shell uname -s),Darwin)
    PERFARENA_RUNNER  ?= $(_POWERMETRICS_RUNNER)
  else ifeq ($(wildcard $(_RAPL_RUNNER)),)
    PERFARENA_RUNNER  ?= $(_CC_RUNNER)
  else
    PERFARENA_RUNNER  ?= $(_RAPL_RUNNER)
  endif
endif

CC  ?= gcc
CXX ?= g++

VALIDATION_N       ?=
REFERENCE_OUTPUT   ?=
BINARY_OUTPUT      ?= 0
_VALIDATION_ACTUAL ?= .perfarena_validate_actual.out

# Build the full run command, appending stdin redirect if needed.
ifdef STDIN_FILE
  _FULL_RUN_CMD = $(RUN_CMD) < $(STDIN_FILE)
  _FULL_VALIDATE_CMD = $(subst $(ARG),$(VALIDATION_N),$(RUN_CMD)) < $(STDIN_FILE)
else
  _FULL_RUN_CMD = $(RUN_CMD)
  _FULL_VALIDATE_CMD = $(subst $(ARG),$(VALIDATION_N),$(RUN_CMD))
endif

.PHONY: compile run measure mem validate clean

compile:
	$(COMPILE_CMD)

run:
	$(RUN_CMD)

measure:
ifeq ($(shell uname -s),Darwin)
	$(PERFARENA_RUNNER) "$(_FULL_RUN_CMD)" $(LANG) $(TEST) $(PERFARENA_WARMUP) $(PERFARENA_MEASURE) $(PERFARENA_IDLE_S)
else
	@if echo "$(PERFARENA_RUNNER)" | grep -q "perfarena_runner$$" && [ ! -x $(PERFARENA_RUNNER) ]; then \
	    echo "perfarena.mk: $(PERFARENA_RUNNER) is missing; build RAPL/ first" >&2 ; \
	    exit 1 ; \
	fi
	sudo modprobe msr || true
	sudo $(PERFARENA_RUNNER) "$(_FULL_RUN_CMD)" $(LANG) $(TEST) $(PERFARENA_WARMUP) $(PERFARENA_MEASURE) $(PERFARENA_IDLE_S)
endif

mem:
ifeq ($(shell uname -s),Darwin)
	/usr/bin/time -l $(_FULL_RUN_CMD)
else
	/usr/bin/time -v $(_FULL_RUN_CMD)
endif

# Correctness oracle: run the benchmark at a small N and compare
# output against the reference. Measurement should be gated behind
# this step.
validate:
	@# One shell block (so exactly ONE path runs). Multi-case CLBG oracle when
	@# reference/clbg/outputs/<problem>/cases.txt exists (>=5 golden cases);
	@# otherwise the single-case REFERENCE_OUTPUT diff (LC cells: /dev/null = PASS).
	@if [ -f "../../../reference/clbg/outputs/$(TEST)/cases.txt" ]; then \
	    if bash ../../../selection/clbg_validate.sh "$(RUN_CMD)" "$(ARG)" "$(TEST)" "$(BINARY_OUTPUT)"; then \
	        echo "validate: PASS" ; \
	    else echo "validate: FAIL" >&2 ; exit 1 ; fi ; \
	elif [ -z "$(REFERENCE_OUTPUT)" ]; then \
	    echo "validate: REFERENCE_OUTPUT is not set for $(LANG)/$(TEST)" >&2 ; exit 1 ; \
	else \
	    echo "validate: running $(TEST) at N=$(VALIDATION_N)..." ; \
	    $(_FULL_VALIDATE_CMD) > $(_VALIDATION_ACTUAL) 2> $(_VALIDATION_ACTUAL).err ; rc=$$? ; \
	    if [ $$rc -ne 0 ]; then \
	        echo "validate: FAIL (program exited $$rc)" >&2 ; cat $(_VALIDATION_ACTUAL).err >&2 ; \
	        rm -f $(_VALIDATION_ACTUAL) $(_VALIDATION_ACTUAL).err ; exit $$rc ; \
	    fi ; \
	    if [ "$(BINARY_OUTPUT)" = "1" ]; then cmp -s $(_VALIDATION_ACTUAL) $(REFERENCE_OUTPUT) ; \
	    else diff -q $(_VALIDATION_ACTUAL) $(REFERENCE_OUTPUT) > /dev/null ; fi && echo "validate: PASS" || { \
	        echo "validate: FAIL (output differs from $(REFERENCE_OUTPUT))" >&2 ; \
	        echo "--- first 20 lines of divergence ---" >&2 ; \
	        diff $(_VALIDATION_ACTUAL) $(REFERENCE_OUTPUT) 2>/dev/null | head -20 >&2 ; \
	        rm -f $(_VALIDATION_ACTUAL) $(_VALIDATION_ACTUAL).err ; exit 1 ; } ; \
	    rm -f $(_VALIDATION_ACTUAL) $(_VALIDATION_ACTUAL).err ; \
	fi

clean:
	rm -f $(OUTPUT)
