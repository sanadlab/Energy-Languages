LANG    = CSharp
TEST    = reverse-complement
SOURCE  = Program.cs
OUTPUT  = bin/Release/reverse-complement
ARG         = 0
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../reference/clbg/inputs/fasta-25000000.txt

include ../../../perfarena.mk
