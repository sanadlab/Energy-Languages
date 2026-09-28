LANG        = TypeScript
TEST        = reverse-complement
SOURCE      = revcomp.ts
OUTPUT      = reverse-complement.js
ARG         = 0
RUN_CMD     = node $(OUTPUT) $(ARG)

COMPILE_CMD = $(TSC) --noCheck --target es2020 --module commonjs --skipLibCheck --outDir . $(SOURCE) && if [ "$(SOURCE:.ts=.js)" != "$(OUTPUT)" ]; then mv $(SOURCE:.ts=.js) $(OUTPUT); fi

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/reverse-complement.txt
STDIN_FILE         = ../../../../reference/clbg/inputs/fasta-25000000.txt

include ../../../../perfarena.mk
