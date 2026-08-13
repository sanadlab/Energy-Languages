# LC-energy minimum-number-of-work-sessions-to-finish-the-tasks (CSharp) — CLBG-shape, dotnet build.
LANG        = CSharp
TEST        = minimum-number-of-work-sessions-to-finish-the-tasks
SOURCE      = solution.cs
OUTPUT      = bin/Release/net10.0/csbench.dll
ARG         =
RUN_CMD     = dotnet bin/Release/net10.0/csbench.dll
COMPILE_CMD = dotnet build -c Release --nologo -v quiet

VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

include ../../../perfarena.mk
