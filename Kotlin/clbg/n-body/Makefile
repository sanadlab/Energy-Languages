LANG    = Kotlin
TEST    = n-body
SOURCE  = nbody.kt
OUTPUT  = nbody.jar
ARG         = 15000000
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt
include ../../../perfarena.mk
