LANG        = Elixir
TEST        = binary-trees
SOURCE      = binarytrees.exs
OUTPUT      = .clbg_build/Elixir.PerfArena.ClbgMain.beam
ARG         = 18
# make compile builds the program ONCE (selection/clbg_elixir_build.exs: the
# modules, plus PerfArena.ClbgMain.main/0 for the top-level code or main/1);
# a run only starts the compiled modules. No erl_crash.dump on a crash.
RUN_CMD     = env ERL_CRASH_DUMP_BYTES=0 elixir -pa .clbg_build -e PerfArena.ClbgMain.main $(ARG)
COMPILE_CMD = rm -rf .clbg_build && elixir ../../../selection/clbg_elixir_build.exs $(SOURCE) .clbg_build

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
