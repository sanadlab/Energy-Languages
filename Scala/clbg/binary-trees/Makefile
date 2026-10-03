LANG    = Scala
TEST    = binary-trees
SOURCE  = binarytrees.scala
OUTPUT  = binarytrees.class
ARG         = 18

# Scala 3's `scala` runner is scala-cli-based and cannot run a bare compiled
# object off a classpath the old way. So compile with scalac and run the main
# class on the JVM directly, putting the Scala runtime library on the classpath.
# The library jars ship under the Homebrew scalac install; locate them relative
# to the resolved scalac binary so no absolute path is baked in.
SCALA_LIBDIR := $(shell cd "$$(dirname "$$(readlink -f "$$(command -v scalac)")")/.." && pwd)/libexec/maven2/org/scala-lang
SCALA_CP     := $(shell ls $(SCALA_LIBDIR)/scala3-library_3/*/scala3-library_3-*.jar $(SCALA_LIBDIR)/scala-library/*/scala-library-*.jar 2>/dev/null | paste -sd: -)

COMPILE_CMD = scalac $(SOURCE) -d .
RUN_CMD = java -cp ".:$(SCALA_CP)" binarytrees $(ARG)

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
