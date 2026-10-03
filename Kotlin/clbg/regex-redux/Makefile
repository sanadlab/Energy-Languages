LANG    = Kotlin
TEST    = regex-redux
SOURCE  = regexredux.kt
OUTPUT  = regexredux.jar
ARG         = 0
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-500000.txt
include ../../../perfarena.mk
