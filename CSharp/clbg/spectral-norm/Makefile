LANG    = CSharp
TEST    = spectral-norm
SOURCE  = Program.cs
OUTPUT  = bin/Release/spectral-norm
ARG         = 4000
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
