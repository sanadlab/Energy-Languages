LANG        = PHP
TEST        = spectral-norm
SOURCE      = spectralnorm.php
OUTPUT      = spectral-norm.php
ARG         = 4000
RUN_CMD     = php -d short_open_tag=On -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 100
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/spectral-norm.txt

include ../../../perfarena.mk
