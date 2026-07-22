LANGUAGE = go
LANGUAGE_FOLDER = Go
LEETCODE_LANGUAGE = golang
SLUG = maximum-total-beauty-of-the-gardens
SOURCE = solution.go
MODEL_SLUG ?= manual__manual
WORKLOAD = ../../../reference/leetcode/workloads/$(SLUG).json
REFERENCE_OUTPUT = ../../../reference/leetcode/outputs/$(SLUG).json

.PHONY: compile validate measure clean

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

clean:
	rm -f compile.json result*.json energy_*.json
	rm -rf __pycache__ .pytest_cache
