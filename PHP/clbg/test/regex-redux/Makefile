LANG        = PHP
TEST        = regex-redux
SOURCE      = regexredux.php
OUTPUT      = regex-redux.php
ARG         = 0
RUN_CMD     = php -d short_open_tag=On -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 0
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/regex-redux.txt
STDIN_FILE         = ../../../../reference/clbg/inputs/fasta-10000.txt

include ../../../../perfarena.mk
