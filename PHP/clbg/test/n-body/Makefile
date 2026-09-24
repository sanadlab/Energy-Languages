LANG        = PHP
TEST        = n-body
SOURCE      = nbody.php-3.php
OUTPUT      = n-body.php
ARG         = 15000000
RUN_CMD     = php -d short_open_tag=On -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/n-body.txt

include ../../../../perfarena.mk
