LANG    = Kotlin
TEST    = fannkuch-redux
SOURCE  = fannkuchredux.kt
OUTPUT  = fannkuchredux.jar
ARG         = 11
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fannkuch-redux.txt
include ../../../perfarena.mk
