LANG        = TypeScript
TEST        = spectral-norm
SOURCE      = spectralnorm.ts
OUTPUT      = spectral-norm.js
ARG         = 4000
RUN_CMD     = node $(OUTPUT) $(ARG)

COMPILE_CMD = $(TSC) --noCheck --target es2020 --module commonjs --skipLibCheck --outDir . $(SOURCE) && if [ "$(SOURCE:.ts=.js)" != "$(OUTPUT)" ]; then mv $(SOURCE:.ts=.js) $(OUTPUT); fi

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
