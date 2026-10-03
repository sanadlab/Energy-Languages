LANG    = Scala
TEST    = regex-redux
SOURCE  = regexredux.scala
OUTPUT  = regexredux.class
ARG         = 0

SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" regexredux $(ARG)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-500000.txt
include ../../../perfarena.mk
