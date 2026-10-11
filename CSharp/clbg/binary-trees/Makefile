LANG    = CSharp
TEST    = binary-trees
SOURCE  = Program.cs
OUTPUT  = bin/Release/binary-trees
ARG         = 18
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/binary-trees.txt

include ../../../perfarena.mk
