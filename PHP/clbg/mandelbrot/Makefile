LANG        = PHP
TEST        = mandelbrot
SOURCE      = mandelbrot.php-3.php
OUTPUT      = mandelbrot.php
ARG         = 7000
RUN_CMD     = php -n -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 200
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/mandelbrot/php.pbm
BINARY_OUTPUT      = 1

include ../../../perfarena.mk
