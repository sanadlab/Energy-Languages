LANG    = CSharp
TEST    = regex-redux
SOURCE  = Program.cs
OUTPUT  = bin/Release/regex-redux
ARG         = 0
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-500000.txt

include ../../../perfarena.mk
