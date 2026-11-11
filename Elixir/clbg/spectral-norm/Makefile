LANG        = Elixir
TEST        = spectral-norm
SOURCE      = spectralnorm.exs
OUTPUT      = .clbg_build/Elixir.PerfArena.ClbgMain.beam
ARG         = 4000
# make compile builds the program ONCE (selection/clbg_elixir_build.exs: the
# modules, plus PerfArena.ClbgMain.main/0 for the top-level code or main/1);
# a run only starts the compiled modules. No erl_crash.dump on a crash.
RUN_CMD     = env ERL_CRASH_DUMP_BYTES=0 elixir -pa .clbg_build -e PerfArena.ClbgMain.main $(ARG)
COMPILE_CMD = rm -rf .clbg_build && elixir ../../../selection/clbg_elixir_build.exs $(SOURCE) .clbg_build

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
