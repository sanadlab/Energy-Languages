LANG    = Scala
TEST    = pidigits
SOURCE  = pidigits.scala
OUTPUT  = pidigits.class
ARG         = 10000

SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" pidigits $(ARG)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt
include ../../../perfarena.mk
