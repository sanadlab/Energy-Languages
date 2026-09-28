LANG        = TypeScript
TEST        = binary-trees
SOURCE      = binarytrees.typescript-2.ts
OUTPUT      = binary-trees.js
ARG         = 18
RUN_CMD     = node $(OUTPUT) $(ARG)

COMPILE_CMD = $(TSC) --noCheck --target es2020 --module commonjs --skipLibCheck --outDir . $(SOURCE) && if [ "$(SOURCE:.ts=.js)" != "$(OUTPUT)" ]; then mv $(SOURCE:.ts=.js) $(OUTPUT); fi

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/binary-trees.txt

include ../../../../perfarena.mk
