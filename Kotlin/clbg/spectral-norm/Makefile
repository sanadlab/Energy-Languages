LANG    = Kotlin
TEST    = spectral-norm
SOURCE  = spectralnorm.kt
OUTPUT  = spectralnorm.jar
ARG         = 4000
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt
include ../../../perfarena.mk
