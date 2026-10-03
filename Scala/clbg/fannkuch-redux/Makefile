LANG    = Scala
TEST    = fannkuch-redux
SOURCE  = fannkuchredux.scala
OUTPUT  = fannkuchredux.class
ARG         = 11

SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" fannkuchredux $(ARG)

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fannkuch-redux.txt
include ../../../perfarena.mk
