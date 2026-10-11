LANG    = CSharp
TEST    = pidigits
SOURCE  = Program.cs
OUTPUT  = bin/Release/pidigits
ARG         = 10000
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/pidigits.txt

include ../../../perfarena.mk
