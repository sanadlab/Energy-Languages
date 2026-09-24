#!/usr/bin/env python3
"""Generate reference-solution smoke-test cells.

For each working CLBG cell <Lang>/clbg/<problem>/, create an immutable copy at
<Lang>/clbg/test/<problem>/ holding the cell's reference SOURCE and a Makefile
with the relative paths bumped one level deeper. These cells are never
overwritten by model submissions, so the oracle can re-run the reference
solutions to confirm the harness still compiles, runs, and validates them.

    python3 selection/gen_reference_tests.py [Lang ...]

With no args it does every <Lang>/clbg. Pass fork language dir names
(C C++ CSharp Java PHP Python TypeScript) to scope it.
"""
import os, re, shutil, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]          # Energy-Languages
PROBLEMS = {"binary-trees","fannkuch-redux","fasta","k-nucleotide","mandelbrot",
            "n-body","pidigits","regex-redux","reverse-complement","spectral-norm"}
SRC_RE = re.compile(r"(?im)^\s*SOURCE\s*=\s*(\S+)")

def gen(langs):
    made, skipped = [], []
    for lang in langs:
        base = ROOT / lang / "clbg"
        if not base.is_dir():
            skipped.append((lang, "*", "no <Lang>/clbg")); continue
        for cell in sorted(p for p in base.iterdir() if p.is_dir() and p.name != "test"):
            prob = cell.name
            if prob not in PROBLEMS:
                continue
            mkf = cell / "Makefile"
            if not mkf.exists():
                skipped.append((lang, prob, "no Makefile")); continue
            text = mkf.read_text()
            m = SRC_RE.search(text)
            if not m:
                skipped.append((lang, prob, "no SOURCE in Makefile")); continue
            src = m.group(1)
            src_file = cell / src
            if not src_file.exists():
                skipped.append((lang, prob, f"SOURCE {src} missing")); continue
            out = base / "test" / prob
            out.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src_file, out / src)
            # TypeScript sources carry a hardcoded `/// <reference
            # path="../node_modules/@types/node/..." />` that resolves at the
            # cell's own depth but not one level deeper. Drop it; tsc still
            # finds @types/node by walking up to an ancestor node_modules.
            if src.endswith(".ts"):
                dst = out / src
                s = dst.read_text()
                s2 = re.sub(r'(?m)^\s*///\s*<reference[^>\n]*node_modules[^>\n]*/>\s*\n',
                            '', s)
                if s2 != s:
                    dst.write_text(s2)
            # Copy build-config files the COMPILE_CMD needs beyond SOURCE
            # (C# cells build a committed .csproj, not Program.cs directly).
            for extra in cell.glob("*.csproj"):
                shutil.copy2(extra, out / extra.name)
            # every ../../../ points to the EL root; test/ is one level deeper.
            out_mk = text.replace("../../../", "../../../../")
            (out / "Makefile").write_text(out_mk)
            made.append((lang, prob, src))
    return made, skipped

if __name__ == "__main__":
    langs = sys.argv[1:] or [p.name for p in ROOT.iterdir()
                             if (p / "clbg").is_dir()]
    made, skipped = gen(langs)
    for l,p,s in made:    print(f"  OK   {l:11} {p:18} <- {s}")
    for l,p,r in skipped: print(f"  SKIP {l:11} {p:18} ({r})")
    print(f"\ngenerated {len(made)} test cells; skipped {len(skipped)}")
