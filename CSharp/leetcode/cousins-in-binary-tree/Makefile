# LC-energy cousins-in-binary-tree (C#) — CLBG-shape (hand-written).
# dotnet build compiles every .cs in the dir into one exe, so
# solution.cs + TestSuite.cs get linked automatically.
LANG        = CSharp
TEST        = cousins-in-binary-tree
SOURCE      = solution.cs
OUTPUT      = bin/Release/net10.0/csbench.dll
ARG         =
RUN_CMD     = dotnet bin/Release/net10.0/csbench.dll
COMPILE_CMD = dotnet build -c Release --nologo -v quiet

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

include ../../../perfarena.mk
