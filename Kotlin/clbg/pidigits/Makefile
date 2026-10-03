LANG    = Kotlin
TEST    = pidigits
SOURCE  = pidigits.kt
OUTPUT  = pidigits.jar
ARG         = 10000
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt
include ../../../perfarena.mk
