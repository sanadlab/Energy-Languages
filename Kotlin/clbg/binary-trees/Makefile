LANG    = Kotlin
TEST    = binary-trees
SOURCE  = binarytrees.kt
OUTPUT  = binarytrees.jar
ARG         = 18
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
