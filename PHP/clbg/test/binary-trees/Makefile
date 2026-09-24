LANG        = PHP
TEST        = binary-trees
SOURCE      = binarytrees.php-5.php
OUTPUT      = binary-trees.php
ARG         = 18
RUN_CMD     = php -d short_open_tag=On -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 10
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/binary-trees.txt

include ../../../../perfarena.mk
