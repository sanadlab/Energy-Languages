LANG    = CSharp
TEST    = chameneos-redux
SOURCE  = Program.cs
OUTPUT  = bin/Release/chameneos-redux
ARG     = 6000000
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

include ../../../perfarena.mk
