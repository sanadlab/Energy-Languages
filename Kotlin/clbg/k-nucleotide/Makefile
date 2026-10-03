LANG    = Kotlin
TEST    = k-nucleotide
SOURCE  = knucleotide.kt
OUTPUT  = knucleotide.jar
ARG         = 0
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/k-nucleotide.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-2500000.txt
include ../../../perfarena.mk
