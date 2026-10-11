LANG    = CSharp
TEST    = mandelbrot
SOURCE  = Program.cs
OUTPUT  = bin/Release/mandelbrot
ARG         = 3504
# Run the built assembly. `dotnet run` would run MSBuild's build check inside
# every measured run; with no build, this fails instead of building.
RUN_CMD = dotnet $(firstword $(wildcard bin/Release/*/$(basename $(wildcard *.csproj)).dll)) $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT      = 1
BINARY_TOLERANCE_BYTES = 16

include ../../../perfarena.mk
