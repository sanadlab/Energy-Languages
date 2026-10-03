LANG    = Scala
TEST    = mandelbrot
SOURCE  = mandelbrot.scala
OUTPUT  = mandelbrot.class
ARG         = 3504

SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" mandelbrot $(ARG)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot/java.pbm
BINARY_OUTPUT      = 1
include ../../../perfarena.mk
