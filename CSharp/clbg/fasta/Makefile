LANG    = CSharp
TEST    = fasta
SOURCE  = Program.cs
OUTPUT  = bin/Release/fasta
ARG         = 12000000
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
