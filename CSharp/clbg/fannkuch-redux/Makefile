LANG    = CSharp
TEST    = fannkuch-redux
SOURCE  = Program.cs
OUTPUT  = bin/Release/fannkuch-redux
ARG         = 11
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 7
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fannkuch-redux.txt

include ../../../perfarena.mk
