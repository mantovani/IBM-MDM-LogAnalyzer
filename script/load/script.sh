#!/bin/ksh

HOME_PATH=/home/hadoop/apps/IBM-MDM-LogAnalyzer/script/load

export PATH=/home/db2inst/sqllib/bin:$PATH

# - Perl
PERL5LIB="/home/hadoop/perl5/lib/perl5${PERL5LIB+:}$PERL5LIB"; 
export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/hadoop/perl5${PERL_LOCAL_LIB_ROOT+:}$PERL_LOCAL_LIB_ROOT";
export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/hadoop/perl5\"";
export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/hadoop/perl5";
export PERL_MM_OPT;

perl ${HOME_PATH}/load.pl > ${HOME_PATH}/data/bulk_load.csv
wc -l ${HOME_PATH}/data/bulk_load.csv
db2 -tvf ${HOME_PATH}/sql/load.sql
