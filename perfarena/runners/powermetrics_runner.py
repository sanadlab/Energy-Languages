"""Direct-powermetrics measurement runner for macOS.

Uses the perfarena PowermetricsSampler (already parsing 100ms plist
samples for the casewise energy pipeline) to integrate CPU + GPU +
ANE power over each measured iteration's wall-clock window. Emits
the same JSONL row schema that ``perfarena_runner.c`` and
``codecarbon_runner.py`` produce so ``measurement.py`` doesn't care
which backend fed the trace — it reads `energy_source` on each row.

Why prefer this over CodeCarbon on macOS: CodeCarbon *does* call
powermetrics under the hood but layers a heavy-weight EmissionsTracker
between us and the sample stream. Direct sampling gives lower
overhead, exact per-iteration windows (not tracker-lifetime
averages), and the same joule figures the paper's methodology
requires.

Requires:
    * macOS
    * passwordless sudo scoped to /usr/bin/powermetrics — set via a
      sudoers rule; verify with ``sudo -n /usr/bin/powermetrics …``.

Usage (called by perfarena.mk when PERFARENA_PROFILER=auto or
=powermetrics on Darwin):

    python -m perfarena.runners.powermetrics_runner \\
        "python3 binarytrees.py 21" Python binary-trees \\
        [warmup=10] [measure=20] [idle_s=5]
"""
from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

from perfarena.casewise_energy import PowermetricsSampler, PowerSample


DEFAULT_WARMUP = 10
DEFAULT_MEASURE = 20
DEFAULT_IDLE_S = 5
SAMPLE_INTERVAL_MS = 100


def _j_to_uj(joules: float) -> int:
    return int(joules * 1_000_000)


def _integrate_energy_j(
    samples: list[PowerSample],
    started_ns: int,
    ended_ns: int,
) -> tuple[float, float, float]:
    """Trapezoidal-ish integral of power over the window.
    Returns (cpu_j, gpu_j, ane_j)."""
    cpu = gpu = ane = 0.0
    for s in samples:
        if s.ended_ns < started_ns or s.started_ns > ended_ns:
            continue
        dt_s = s.elapsed_ns / 1e9
        cpu += (s.cpu_w or 0.0) * dt_s
        if s.gpu_w is not None:
            gpu += s.gpu_w * dt_s
        if s.ane_w is not None:
            ane += s.ane_w * dt_s
    return cpu, gpu, ane


def _write_row(
    out: Any,
    *,
    test: str,
    language: str,
    iteration: int,
    phase: str,
    wall_ms: float,
    energy_uj: int,
    energy_source: str,
    samples_count: int,
    exit_code: int,
    extra: dict[str, Any] | None = None,
) -> None:
    row: dict[str, Any] = {
        "schema_version": 1,
        "test": test,
        "language": language,
        "iteration": iteration,
        "phase": phase,
        "wall_ms": round(wall_ms, 3),
        # Same field name the RAPL runner uses so measurement.py ingest
        # doesn't need to branch on backend. `energy_source` on each row
        # tells you the unit interpretation (RAPL raw ticks vs
        # microjoules); for both codecarbon and powermetrics this is
        # already-scaled microjoules.
        "rapl_pkg_start_raw": 0,
        "rapl_pkg_end_raw": 0,
        "rapl_pkg_delta_raw": energy_uj,
        "energy_source": energy_source,
        "samples": samples_count,
        "exit_code": exit_code,
    }
    if extra:
        row["extra"] = extra
    out.write(json.dumps(row) + "\n")
    out.flush()


def _run_child(command: str, timeout: float = 600.0) -> tuple[int, int, int]:
    """Run a shell command. Returns (exit_code, started_ns, ended_ns)
    in monotonic_ns so the caller can align them with the sampler."""
    started = time.monotonic_ns()
    proc = subprocess.run(
        ["sh", "-c", command],
        capture_output=True,
        timeout=timeout,
    )
    ended = time.monotonic_ns()
    return proc.returncode, started, ended


def main(argv: list[str] | None = None) -> int:
    args = argv if argv is not None else sys.argv[1:]
    if len(args) < 3:
        print(
            f"usage: {sys.argv[0]} \"<command>\" <language> <test> "
            f"[warmup={DEFAULT_WARMUP}] [measure={DEFAULT_MEASURE}] "
            f"[idle_s={DEFAULT_IDLE_S}]",
            file=sys.stderr,
        )
        return 2

    command  = args[0]
    language = args[1]
    test     = args[2]
    warmup   = int(args[3]) if len(args) > 3 else DEFAULT_WARMUP
    measure  = int(args[4]) if len(args) > 4 else DEFAULT_MEASURE
    idle_s   = int(args[5]) if len(args) > 5 else DEFAULT_IDLE_S

    out_path = Path(f"../{language}.jsonl")
    out = out_path.open("a")

    # ---- Pre-flight the sampler (fails clearly if sudo isn't set up) --
    try:
        PowermetricsSampler.preflight()
    except RuntimeError as e:
        # Fall back to wall-clock-only rows so a run without sudo still
        # produces the same JSONL shape (energy_source="none"). This
        # matches codecarbon_runner's behaviour when codecarbon isn't
        # installed.
        print(f"[powermetrics-runner] preflight failed: {e}",
              file=sys.stderr)
        return _degraded_run(
            out, command, language, test, warmup, measure, idle_s, str(e),
        )

    # ---- Start the sampler once for the whole run ---------------------
    with tempfile.NamedTemporaryFile(
        prefix="perfarena_powermetrics_", suffix=".plist", delete=False,
    ) as tf:
        raw_path = Path(tf.name)
    sampler = PowermetricsSampler(raw_path, interval_ms=SAMPLE_INTERVAL_MS)
    print(f"[powermetrics-runner] starting sampler "
          f"(interval={SAMPLE_INTERVAL_MS}ms → {raw_path})",
          file=sys.stderr)
    sampler.start()
    try:
        # ---- Idle baseline ------------------------------------------------
        print(f"[powermetrics-runner] idle baseline ({idle_s}s)…",
              file=sys.stderr)
        idle_started = time.monotonic_ns()
        time.sleep(idle_s)
        idle_ended = time.monotonic_ns()
        sampler.wait_for_window(idle_ended)
        idle_samples = sampler.samples_for_window(idle_started, idle_ended)
        cpu_j, gpu_j, ane_j = _integrate_energy_j(
            idle_samples, idle_started, idle_ended,
        )
        _write_row(
            out,
            test=test, language=language, iteration=0, phase="idle",
            wall_ms=(idle_ended - idle_started) / 1e6,
            energy_uj=_j_to_uj(cpu_j),
            energy_source="powermetrics",
            samples_count=len(idle_samples),
            exit_code=0,
            extra={
                "cpu_energy_j":  cpu_j,
                "gpu_energy_j":  gpu_j,
                "ane_energy_j":  ane_j,
                "thermal":       sampler.latest_thermal(),
                "sample_interval_ms": SAMPLE_INTERVAL_MS,
            },
        )

        # ---- Warm-up + measurement ---------------------------------------
        total = warmup + measure
        for i in range(total):
            phase = "warmup" if i < warmup else "measure"
            print(f"[powermetrics-runner] {phase} {i + 1}/{total}…",
                  file=sys.stderr)
            exit_code, started_ns, ended_ns = _run_child(command)
            # Give the sampler enough time to capture the tail window.
            sampler.wait_for_window(ended_ns)
            iter_samples = sampler.samples_for_window(started_ns, ended_ns)
            cpu_j, gpu_j, ane_j = _integrate_energy_j(
                iter_samples, started_ns, ended_ns,
            )
            _write_row(
                out,
                test=test, language=language, iteration=i + 1, phase=phase,
                wall_ms=(ended_ns - started_ns) / 1e6,
                energy_uj=_j_to_uj(cpu_j),
                energy_source="powermetrics",
                samples_count=len(iter_samples),
                exit_code=exit_code,
                extra={
                    "cpu_energy_j":  cpu_j,
                    "gpu_energy_j":  gpu_j,
                    "ane_energy_j":  ane_j,
                    "thermal":       sampler.latest_thermal(),
                    "sample_interval_ms": SAMPLE_INTERVAL_MS,
                },
            )
    finally:
        sampler.stop()
        try:
            raw_path.unlink()
        except OSError:
            pass
        out.close()
        print(f"[powermetrics-runner] done. wrote {out_path}",
              file=sys.stderr)
    return 0


def _degraded_run(
    out, command: str, language: str, test: str,
    warmup: int, measure: int, idle_s: int, error: str,
) -> int:
    """Same iteration count / JSONL shape but energy_source='none' and
    energy_uj=0 — so a run without sudo still emits a valid trace.
    Callers can check energy_source to decide whether to trust the
    row's energy numbers."""
    # Idle
    t0 = time.monotonic()
    time.sleep(idle_s)
    _write_row(
        out,
        test=test, language=language, iteration=0, phase="idle",
        wall_ms=(time.monotonic() - t0) * 1000,
        energy_uj=0, energy_source="none",
        samples_count=0, exit_code=0,
        extra={"note": f"powermetrics preflight failed: {error}"},
    )
    total = warmup + measure
    for i in range(total):
        phase = "warmup" if i < warmup else "measure"
        print(f"[powermetrics-runner:degraded] {phase} {i + 1}/{total}…",
              file=sys.stderr)
        exit_code, s_ns, e_ns = _run_child(command)
        _write_row(
            out,
            test=test, language=language, iteration=i + 1, phase=phase,
            wall_ms=(e_ns - s_ns) / 1e6,
            energy_uj=0, energy_source="none",
            samples_count=0, exit_code=exit_code,
        )
    out.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
