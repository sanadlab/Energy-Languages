LANG    = Scala
TEST    = spectral-norm
SOURCE  = spectralnorm.scala
OUTPUT  = spectralnorm.class
ARG         = 4000

SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" spectralnorm $(ARG)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt
include ../../../perfarena.mk
