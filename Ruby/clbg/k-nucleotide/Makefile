LANG        = Ruby
TEST        = k-nucleotide
SOURCE      = knucleotide.yarv-7.yarv
OUTPUT      = k-nucleotide.rb
ARG         = 21
RUN_CMD     = ruby $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-10000.txt

include ../../../perfarena.mk
