LANG    = CSharp
TEST    = mandelbrot
SOURCE  = Program.cs
OUTPUT  = bin/Release/mandelbrot
ARG         = 3504
RUN_CMD = dotnet run --configuration Release -- $(ARG)

COMPILE_CMD = dotnet build --configuration Release --nologo

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT      = 1
BINARY_TOLERANCE_BYTES = 16

include ../../../../perfarena.mk
