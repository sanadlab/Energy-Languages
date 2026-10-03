LANG    = Kotlin
TEST    = reverse-complement
SOURCE  = revcomp.kt
OUTPUT  = revcomp.jar
ARG         = 0
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-25000000.txt
include ../../../perfarena.mk
