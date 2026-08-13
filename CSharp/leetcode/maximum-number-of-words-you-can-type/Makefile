# LC-energy maximum-number-of-words-you-can-type (CSharp) — CLBG-shape, dotnet build.
LANG        = CSharp
TEST        = maximum-number-of-words-you-can-type
SOURCE      = solution.cs
OUTPUT      = bin/Release/net10.0/csbench.dll
ARG         =
RUN_CMD     = dotnet bin/Release/net10.0/csbench.dll
COMPILE_CMD = dotnet build -c Release --nologo -v quiet

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

include ../../../perfarena.mk
