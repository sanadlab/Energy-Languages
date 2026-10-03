LANG    = Kotlin
TEST    = mandelbrot
SOURCE  = mandelbrot.kt
OUTPUT  = mandelbrot.jar
ARG         = 3504
RUN_CMD = java -jar $(OUTPUT) $(ARG)

COMPILE_CMD = kotlinc $(SOURCE) -include-runtime -d $(OUTPUT)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot/java.pbm
BINARY_OUTPUT      = 1
include ../../../perfarena.mk
