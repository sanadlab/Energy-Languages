LANG    = Erlang
TEST    = spectral-norm
SOURCE  = spectralnorm.erl
MOD     = spectralnorm
OUTPUT  = spectralnorm.beam

ARG         = 4000
RUN_CMD     = erl -noshell -pa . -run $(MOD) main $(ARG) -s init stop
COMPILE_CMD = erlc $(SOURCE)

VALIDATION_N     = 100
REFERENCE_OUTPUT = ../../../reference/clbg/outputs/spectral-norm.txt
include ../../../perfarena.mk
