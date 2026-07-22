"""Restructure the fork from
    <root>/<Lang>/<clbg-slug>/                (CLBG at root)
    <root>/leetcode-energy/<Lang>/<lc-slug>/  (LC in subdir)
to
    <root>/<Lang>/<competition>/<slug>/       (unified)

Also relocates reference/ into competition-scoped subtrees.

Uses `git mv` so history is preserved. Runs `git status` before doing
anything and aborts if there are uncommitted changes; that way an
accidental invocation can't stomp on other work.

Usage:
    python scripts/restructure_to_lang_competition_problem.py --dry-run
    python scripts/restructure_to_lang_competition_problem.py --apply
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


CLBG_SLUGS = {
    "binary-trees", "fannkuch-redux", "fasta", "k-nucleotide",
    "mandelbrot", "n-body", "pidigits", "regex-redux",
    "reverse-complement", "spectral-norm",
}
# A few forks have extra bonus problems in some languages
# (`chameneos-redux`, `thread-ring`, `meteor`, `pi-digits`). We move
# ANY cell directory sitting at `<Lang>/<slug>/` under `<Lang>/clbg/`
# — the CLBG_SLUGS set is used only for reporting, not filtering.

# Every fork subfolder that IS a language folder (not perfarena internals).
LANG_FOLDERS = {
    "Ada", "C", "C++", "CSharp", "Chapel", "Dart", "Erlang", "FSharp",
    "Fortran", "Go", "Hack", "Haskell", "JRuby", "Java", "Java-GraalVM",
    "JavaScript", "Julia", "Lisp", "Lua", "OCaml", "PHP", "Pascal",
    "Perl", "Python", "Racket", "Ruby", "Rust", "Smalltalk", "Swift",
    "TypeScript",
}


def _sh(cmd: list[str], cwd: Path, dry: bool) -> None:
    if dry:
        print("  (dry) $", " ".join(cmd))
        return
    subprocess.run(cmd, cwd=str(cwd), check=True)


def _ensure_clean_tree(root: Path) -> None:
    r = subprocess.run(
        ["git", "status", "--porcelain"],
        cwd=str(root), capture_output=True, text=True, check=True,
    )
    # Ignore this script itself in the pre-flight — it lives in the
    # same repo it's about to restructure, so requiring it to be
    # committed first would be gratuitous. Every OTHER change fails.
    _SCRIPT_REL = "scripts/restructure_to_lang_competition_problem.py"
    offending = [
        ln for ln in r.stdout.splitlines()
        if ln.strip() and _SCRIPT_REL not in ln
    ]
    if offending:
        print("ERROR: repo has uncommitted changes — commit or stash first.",
              file=sys.stderr)
        print("\n".join(offending), file=sys.stderr)
        sys.exit(2)


def _mv(root: Path, src: str, dst: str, dry: bool) -> None:
    """git mv wrapper that mkdir -p's the destination parent first
    (git mv fails if the parent doesn't exist)."""
    dst_parent = Path(dst).parent
    if str(dst_parent) not in (".", ""):
        _sh(["mkdir", "-p", str(dst_parent)], cwd=root, dry=dry)
    _sh(["git", "mv", src, dst], cwd=root, dry=dry)


def _rewrite_makefile(mk: Path, replacements: list[tuple[str, str]],
                      dry: bool) -> None:
    """Replace each old→new pair in `mk`. Idempotent — only writes if
    a substitution actually changed content."""
    text = mk.read_text()
    orig = text
    for old, new in replacements:
        text = text.replace(old, new)
    if text == orig:
        return
    print(f"  patched paths in {mk.relative_to(mk.parents[3])}"
          if len(mk.parents) >= 4 else f"  patched {mk}")
    if not dry:
        mk.write_text(text)


def restructure(root: Path, dry: bool) -> None:
    print("--- pre-flight ---")
    _ensure_clean_tree(root)

    # ---- 1. Merge references ---------------------------------------------
    print("\n--- 1. Merge reference/ trees into reference/{competition}/ ---")
    # CLBG side: reference/{inputs,outputs} → reference/clbg/{inputs,outputs}
    for sub in ("inputs", "outputs"):
        src = root / "reference" / sub
        if src.is_dir():
            _mv(root, f"reference/{sub}", f"reference/clbg/{sub}", dry=dry)
    # LC side: leetcode-energy/reference/{workloads,outputs} + README
    lc_ref = root / "leetcode-energy" / "reference"
    if lc_ref.is_dir():
        for entry in sorted(lc_ref.iterdir()):
            _mv(root,
                f"leetcode-energy/reference/{entry.name}",
                f"reference/leetcode/{entry.name}",
                dry=dry)

    # ---- 2. Move CLBG cells: <Lang>/<slug>/ → <Lang>/clbg/<slug>/ --------
    print("\n--- 2. Move CLBG cells → <Lang>/clbg/<slug>/ ---")
    for lang in sorted(LANG_FOLDERS):
        ldir = root / lang
        if not ldir.is_dir():
            continue
        for entry in sorted(ldir.iterdir()):
            # Only touch cell dirs (contain a Makefile). Skip the
            # `clbg/` and `leetcode/` staging dirs if they already exist
            # from a partial prior run.
            if not entry.is_dir():
                continue
            if entry.name in ("clbg", "leetcode"):
                continue
            if not (entry / "Makefile").is_file():
                continue
            _mv(root,
                f"{lang}/{entry.name}",
                f"{lang}/clbg/{entry.name}",
                dry=dry)

    # ---- 3. Move LC cells: leetcode-energy/<Lang>/<slug>/ → <Lang>/leetcode/<slug>/
    print("\n--- 3. Move LC cells → <Lang>/leetcode/<slug>/ ---")
    lc_root = root / "leetcode-energy"
    if lc_root.is_dir():
        for lang_dir in sorted(lc_root.iterdir()):
            if not lang_dir.is_dir() or lang_dir.name == "reference":
                continue
            lang = lang_dir.name
            for cell in sorted(lang_dir.iterdir()):
                if not cell.is_dir():
                    continue
                if not (cell / "Makefile").is_file():
                    continue
                _mv(root,
                    f"leetcode-energy/{lang}/{cell.name}",
                    f"{lang}/leetcode/{cell.name}",
                    dry=dry)

    # ---- 4. Remove empty leetcode-energy/ if it exists ------------------
    if not dry and (root / "leetcode-energy").is_dir():
        # After all children moved, git mv left the parent directory
        # empty. `git rm -r` cleanly handles the case where nothing
        # tracked remains inside it.
        remaining = list((root / "leetcode-energy").rglob("*"))
        if not remaining:
            _sh(["rmdir", "leetcode-energy"], cwd=root, dry=False)
        else:
            print("  NOTE: leetcode-energy/ still contains files "
                  f"({len(remaining)}) — inspect manually")

    # ---- 5. Rewrite Makefile relative paths -----------------------------
    print("\n--- 4. Rewrite relative paths in cell Makefiles ---")
    # CLBG cells at NEW location <Lang>/clbg/<slug>/ need one extra `..`
    # AND their reference references gain the `/clbg/` prefix.
    for lang in sorted(LANG_FOLDERS):
        clbg_dir = root / lang / "clbg"
        if not clbg_dir.is_dir():
            continue
        for cell in sorted(clbg_dir.iterdir()):
            mk = cell / "Makefile"
            if mk.is_file():
                _rewrite_makefile(mk, [
                    # perfarena.mk moves up one more level
                    ("../../perfarena.mk", "../../../perfarena.mk"),
                    # references live at reference/clbg/{inputs,outputs}/...
                    ("../../reference/outputs/", "../../../reference/clbg/outputs/"),
                    ("../../reference/inputs/", "../../../reference/clbg/inputs/"),
                ], dry=dry)
        # LC cells at NEW location <Lang>/leetcode/<slug>/
        lc_dir = root / lang / "leetcode"
        if not lc_dir.is_dir():
            continue
        for cell in sorted(lc_dir.iterdir()):
            mk = cell / "Makefile"
            if mk.is_file():
                _rewrite_makefile(mk, [
                    # LC cells reference workloads/outputs under
                    # reference/leetcode/
                    ("../../reference/workloads/", "../../../reference/leetcode/workloads/"),
                    ("../../reference/outputs/", "../../../reference/leetcode/outputs/"),
                    # (No perfarena.mk include in LC cells today, but
                    # if that changes we want the same fix-up.)
                    ("../../perfarena.mk", "../../../perfarena.mk"),
                ], dry=dry)

    print("\n--- summary ---")
    r = subprocess.run(
        ["git", "status", "--short"],
        cwd=str(root), capture_output=True, text=True, check=True,
    )
    lines = r.stdout.splitlines()
    print(f"  {len(lines)} tracked change(s) staged / working-tree change(s)")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root",
                    default="/Users/rar9993/repos/research/leetcode_crawler"
                            "/Energy-Languages",
                    type=Path)
    grp = ap.add_mutually_exclusive_group(required=True)
    grp.add_argument("--dry-run", action="store_true",
                     help="print the moves that would happen; touch nothing.")
    grp.add_argument("--apply", action="store_true",
                     help="perform the git mv + Makefile rewrites.")
    args = ap.parse_args()
    restructure(args.root, dry=args.dry_run)


if __name__ == "__main__":
    main()
