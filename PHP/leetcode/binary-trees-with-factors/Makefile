LANGUAGE = php
LEETCODE_LANGUAGE = php
SLUG = binary-trees-with-factors
SOURCE = solution.php
MODEL_SLUG ?= manual__manual
WORKLOAD = ../../../reference/leetcode/workloads/$(SLUG).json
REFERENCE_OUTPUT = ../../../reference/leetcode/outputs/$(SLUG).json

.PHONY: compile validate measure clean

compile:
	perfarena leetcode-compile --language $(LANGUAGE) --source $(SOURCE) --result compile.json

validate:
	@# LC validation stub: verifies the source file parses without syntax
	@# errors. Full per-case correctness lives in
	@# `perfarena leetcode-workload-run` which needs
	@# `reference/leetcode/outputs/$(SLUG).json` — not populated upstream
	@# yet. Skip cleanly so downstream targets (measure) don't error out.
	@if [ "$(LANGUAGE)" = "python" ]; then \
	    python3 -m py_compile $(SOURCE) && echo "validate: PASS (py_compile only)" ; \
	else \
	    echo "validate: SKIPPED (LANGUAGE=$(LANGUAGE) — no inline validator yet)" ; \
	fi

measure: validate
	perfarena leetcode-measure --language $(LANGUAGE) --problems $(SLUG) --model-slug $(MODEL_SLUG) --accepted-only

clean:
	rm -f compile.json result*.json energy_*.json
	rm -rf __pycache__ .pytest_cache
