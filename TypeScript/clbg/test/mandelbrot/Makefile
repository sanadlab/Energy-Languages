LANG        = TypeScript
TEST        = mandelbrot
SOURCE      = mandelbrot.ts
OUTPUT      = mandelbrot.js
ARG         = 3504
RUN_CMD     = node $(OUTPUT) $(ARG)

COMPILE_CMD = $(TSC) --noCheck --target es2020 --module commonjs --skipLibCheck --outDir . $(SOURCE) && if [ "$(SOURCE:.ts=.js)" != "$(OUTPUT)" ]; then mv $(SOURCE:.ts=.js) $(OUTPUT); fi

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/mandelbrot.pbm
BINARY_OUTPUT      = 1
BINARY_TOLERANCE_BYTES = 16

include ../../../../perfarena.mk
