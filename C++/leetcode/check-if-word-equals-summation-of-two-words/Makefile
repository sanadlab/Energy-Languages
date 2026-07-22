LANGUAGE = cpp
LANGUAGE_FOLDER = C++
LEETCODE_LANGUAGE = cpp
SLUG = check-if-word-equals-summation-of-two-words
SOURCE = solution.cpp
MODEL_SLUG ?= manual__manual
WORKLOAD = ../../../reference/leetcode/workloads/$(SLUG).json
REFERENCE_OUTPUT = ../../../reference/leetcode/outputs/$(SLUG).json

.PHONY: compile validate measure clean run mem

compile:
	perfarena leetcode-compile --language $(LANGUAGE) --source $(SOURCE) --result compile.json

validate:
	perfarena leetcode-workload-run --language $(LANGUAGE) --problem $(SLUG) --source $(SOURCE) --workload $(WORKLOAD) --expected $(REFERENCE_OUTPUT)

measure: validate
	@# LC-energy measure: run the workload N times under the active profiler.
	@# leetcode-workload-measure captures per-case wall-time; the profiler
	@# (codecarbon / powermetrics / RAPL, selected by PERFARENA_PROFILER)
	@# wraps the whole invocation and integrates energy over that window.
	@# Warmup+measure counts come from the same env vars CLBG uses so the
	@# knobs are consistent across problem sets.
	perfarena leetcode-workload-measure --language $(LANGUAGE) --problem $(SLUG) --source $(SOURCE) --workload $(WORKLOAD) --warmup $${PERFARENA_WARMUP:-1} --measure $${PERFARENA_MEASURE:-3} --language-folder $(LANGUAGE_FOLDER)

run:
	@# LC-energy `run`: single workload pass, no timing / no profiler.
	@# clbg_handler._measure_mem spawns `make run` in a fresh Python
	@# subprocess and reads RUSAGE_CHILDREN — that's the paper's
	@# split-run methodology (memory measured separately from
	@# energy+time so the mem tracker's overhead doesn't inflate the
	@# perf number).
	@if [ "$(LANGUAGE)" = "python" ]; then \
	    python3 ../../../scripts/lc_run_one_pass.py --source $(SOURCE) --workload $(WORKLOAD) ; \
	else \
	    echo "run: skipped (LANGUAGE=$(LANGUAGE) — non-Python LC cells have no runnable main() yet)" ; \
	fi

mem: run
	@# LC-energy `mem`: no-op target since the caller (clbg_handler.
	@# _measure_mem) invokes `make run` in a subprocess and reads
	@# RUSAGE_CHILDREN itself. Kept as a first-class target so `make
	@# mem` matches the CLBG contract for symmetry.
	@true

clean:
	rm -f compile.json result*.json energy_*.json
	rm -rf __pycache__ .pytest_cache
