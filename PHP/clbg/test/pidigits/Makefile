LANG        = PHP
TEST        = pidigits
SOURCE      = pidigits.php-5.php
OUTPUT      = pidigits.php
ARG         = 10000
RUN_CMD     = php -d short_open_tag=On -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 28
REFERENCE_OUTPUT   = ../../../../reference/clbg/outputs/pidigits.txt

include ../../../../perfarena.mk
