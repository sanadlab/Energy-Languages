"""Autonomous smoke over every (language, LC-problem) cell in the tree.

For each cell that (a) exists in the Energy-Languages tree and (b) has
at least one Accepted submission stored in the arena DB, this pulls
ONE Accepted solution and drives it through `make clean compile &&
make run` to prove the perf pipeline can actually execute it.

Records per-cell: status (ok / compile_fail / run_fail / timeout /
skip), wall-clock, and stderr tail. Prints a running per-language
summary as it goes. Writes the full result set to a JSON file at the
end.

Idempotent-ish: each cell's `solution.<ext>` is overwritten with the
accepted code, so a re-run repeats from scratch. The cell's other
files (test_suite / Makefile) are untouched.

Usage:
    .venv-runner/bin/python scripts/verify_all_cells.py
    .venv-runner/bin/python scripts/verify_all_cells.py --languages Python,Java
    .venv-runner/bin/python scripts/verify_all_cells.py --limit 3
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent

# arena `submission.language` → LC-energy folder + solution ext.
LANG_MAP = {
    "python3":    ("Python",     ".py"),
    "cpp":        ("C++",        ".cpp"),
    "csharp":     ("CSharp",     ".cs"),
    "golang":     ("Go",         ".go"),
    "java":       ("Java",       ".java"),
    "javascript": ("JavaScript", ".js"),
    "php":        ("PHP",        ".php"),
    "ruby":       ("Ruby",       ".rb"),
    "rust":       ("Rust",       ".rs"),
    "typescript": ("TypeScript", ".ts"),
}

# Per-cell wall-clock cap. Compilation of Rust cells is the outlier;
# `rustc -O` on a linked-list problem takes 5–10 s. Cap conservatively.
COMPILE_TIMEOUT = 60.0
RUN_TIMEOUT     = 60.0


def _fetch_accepted_solutions(languages: list[str]) -> list[tuple[str, str, str]]:
    """Query the arena DB via `docker exec perfarena` for one accepted
    solution per (language, slug). Returns [(language, slug, code), …]."""
    lang_filter = ",".join(f"'{l}'" for l in languages)
    sql = f"""
    WITH ranked AS (
        SELECT
            s.language,
            p.title_slug,
            a.code,
            row_number() OVER (
                PARTITION BY s.language, p.title_slug
                ORDER BY a.id ASC
            ) AS rn
        FROM submission s
        JOIN attempt a ON a.submission_id = s.id
        JOIN run r     ON r.attempt_id = a.id
        JOIN problem p ON p.id = a.problem_id
        WHERE r.status_msg = 'Accepted'
          AND s.language IN ({lang_filter})
    )
    SELECT language, title_slug, code FROM ranked WHERE rn = 1
    ORDER BY language, title_slug
    """
    # Use docker exec to run the query and stream JSON lines back.
    script = (
        "from app.db import engine\n"
        "from sqlalchemy import text\n"
        "import json, sys\n"
        f"q = '''{sql}'''\n"
        "with engine.connect() as c:\n"
        "    for r in c.execute(text(q)):\n"
        "        print(json.dumps({'lang': r[0], 'slug': r[1], 'code': r[2]}))\n"
    )
    proc = subprocess.run(
        ["docker", "exec", "-i", "perfarena", "python3", "-c", script],
        capture_output=True, text=True, check=True, timeout=120.0,
    )
    out: list[tuple[str, str, str]] = []
    for line in proc.stdout.splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        out.append((row["lang"], row["slug"], row["code"]))
    return out


def _cell_dir(lang_arena: str, slug: str) -> Path | None:
    if lang_arena not in LANG_MAP:
        return None
    folder, _ext = LANG_MAP[lang_arena]
    cell = ROOT / folder / "leetcode" / slug
    if (cell / "Makefile").exists():
        return cell
    return None


def _solution_filename(lang_arena: str) -> str:
    """LC-energy cells use lowercase `solution.<ext>` for every language.
    The one-off is CSharp, which the codegen also emits as `solution.cs`."""
    _folder, ext = LANG_MAP[lang_arena]
    return f"solution{ext}"


def _run(cmd: list[str], cwd: Path, timeout: float
        ) -> tuple[int, float, str, str]:
    t0 = time.perf_counter()
    try:
        p = subprocess.run(
            cmd, cwd=str(cwd),
            capture_output=True, text=True, timeout=timeout,
        )
        wall = time.perf_counter() - t0
        return p.returncode, wall, p.stdout, p.stderr
    except subprocess.TimeoutExpired:
        wall = time.perf_counter() - t0
        return 124, wall, "", f"(timed out after {timeout:.0f}s)"


def _verify_one(lang_arena: str, slug: str, code: str) -> dict:
    cell = _cell_dir(lang_arena, slug)
    if cell is None:
        return {"lang": lang_arena, "slug": slug, "status": "skip_no_cell"}
    src = cell / _solution_filename(lang_arena)
    try:
        src.write_text(code)
    except OSError as e:
        return {"lang": lang_arena, "slug": slug, "status": "skip_write_fail",
                "note": str(e)[:200]}

    # 1. clean + compile
    rc, wall_c, _, err_c = _run(
        ["make", "-s", "clean", "compile"], cell, COMPILE_TIMEOUT,
    )
    if rc != 0:
        return {
            "lang": lang_arena, "slug": slug, "status": "compile_fail",
            "compile_ms": round(wall_c * 1000, 1),
            "err": err_c[-500:],
        }

    # 2. run
    rc, wall_r, out_r, err_r = _run(
        ["make", "-s", "run"], cell, RUN_TIMEOUT,
    )
    if rc != 0:
        return {
            "lang": lang_arena, "slug": slug, "status": "run_fail",
            "compile_ms": round(wall_c * 1000, 1),
            "run_ms":     round(wall_r * 1000, 1),
            "err": err_r[-500:],
        }

    return {
        "lang": lang_arena, "slug": slug, "status": "ok",
        "compile_ms": round(wall_c * 1000, 1),
        "run_ms":     round(wall_r * 1000, 1),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--languages", default="",
                    help="Comma-separated arena language keys (default: all 10).")
    ap.add_argument("--slugs", default="",
                    help="Comma-separated slugs (default: every accepted pair).")
    ap.add_argument("--limit", type=int, default=0,
                    help="Cap the number of cells per language.")
    ap.add_argument("--out", default="scripts/verify_all_cells_results.json",
                    type=Path, help="Where to write results.")
    args = ap.parse_args()

    langs = ([x.strip() for x in args.languages.split(",") if x.strip()]
             if args.languages else list(LANG_MAP))
    slugs_wanted = ({s.strip() for s in args.slugs.split(",") if s.strip()}
                    if args.slugs else None)

    print(f"Fetching accepted solutions for languages: {langs}", flush=True)
    all_rows = _fetch_accepted_solutions(langs)
    if slugs_wanted:
        all_rows = [r for r in all_rows if r[1] in slugs_wanted]

    # Group per language for progress reporting
    by_lang: dict[str, list[tuple[str, str, str]]] = {}
    for row in all_rows:
        by_lang.setdefault(row[0], []).append(row)

    if args.limit:
        for k in by_lang:
            by_lang[k] = by_lang[k][:args.limit]

    total = sum(len(v) for v in by_lang.values())
    print(f"Will verify {total} cell(s) total across "
          f"{len(by_lang)} language(s).\n", flush=True)

    results: list[dict] = []
    counters: dict[str, dict[str, int]] = {}
    for lang, rows in sorted(by_lang.items()):
        counters[lang] = {"ok": 0, "compile_fail": 0, "run_fail": 0,
                          "skip_no_cell": 0, "skip_write_fail": 0}
        print(f"\n=== {lang} ({len(rows)} cell(s)) ===", flush=True)
        for i, (lang_a, slug, code) in enumerate(rows, start=1):
            r = _verify_one(lang_a, slug, code)
            counters[lang][r["status"]] = counters[lang].get(r["status"], 0) + 1
            results.append(r)
            mark = {
                "ok":              "✓",
                "compile_fail":    "✗ compile",
                "run_fail":        "✗ run",
                "skip_no_cell":    "-",
                "skip_write_fail": "?",
            }.get(r["status"], "?")
            timing = ""
            if "compile_ms" in r:
                timing = f"  (compile {r['compile_ms']:.0f}ms"
                if "run_ms" in r:
                    timing += f" · run {r['run_ms']:.0f}ms"
                timing += ")"
            print(f"  [{i:3d}/{len(rows)}] {mark:10s} {slug}{timing}",
                  flush=True)

    # Summary
    print("\n" + "=" * 60, flush=True)
    print("SUMMARY:", flush=True)
    for lang, c in counters.items():
        line = f"  {lang:12s}  ok={c['ok']:3d}  compile_fail={c['compile_fail']:3d}  " \
               f"run_fail={c['run_fail']:3d}  skip={c.get('skip_no_cell', 0) + c.get('skip_write_fail', 0):3d}"
        print(line, flush=True)
    total_ok = sum(c["ok"] for c in counters.values())
    print(f"  OK: {total_ok}/{total}", flush=True)

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps({
        "counters": counters,
        "results":  results,
    }, indent=2))
    print(f"\nWrote {args.out}", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
