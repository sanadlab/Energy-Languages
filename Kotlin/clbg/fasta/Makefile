LANG    = Kotlin
TEST    = fasta
SOURCE  = fasta.kt
OUTPUT  = fasta.jar
ARG         = 12000000
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt
include ../../../perfarena.mk
