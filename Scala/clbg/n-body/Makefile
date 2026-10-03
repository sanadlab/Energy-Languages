LANG    = Scala
TEST    = n-body
SOURCE  = nbody.scala
OUTPUT  = nbody.class
ARG         = 15000000

SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" nbody $(ARG)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/n-body.txt
include ../../../perfarena.mk
