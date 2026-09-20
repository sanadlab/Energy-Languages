LANG        = PHP
TEST        = fasta
SOURCE      = fasta.php-3.php
OUTPUT      = fasta.php
ARG         = 12000000
RUN_CMD     = php -d short_open_tag=On -d memory_limit=2G $(OUTPUT) $(ARG)
COMPILE_CMD = cp $(SOURCE) $(OUTPUT)

VALIDATION_N       = 1000
REFERENCE_OUTPUT   = ../../../reference/clbg/outputs/fasta.txt

include ../../../perfarena.mk
