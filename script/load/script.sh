#!/bin/bash

perl load.pl $1 $2|psql mdm_analyzer -c "\COPY analyzer (name,run,operation,delay,date) FROM STDIN with delimiter ',' "
