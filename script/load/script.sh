#!/bin/ksh

# Your home instalation

HOME_PATH=/home/hadoop/apps/IBM-MDM-LogAnalyzer

# Your DB2 HOME

DB2_HOME=/home/db2inst/sqllib

PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}$PERL5LIB";
export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}$PERL_LOCAL_LIB_ROOT";
export PERL_LOCAL_LIB_ROOT;


perl ${HOME_PATH}/script/load/load2.pl > ${HOME_PATH}/script/load/data/bulk_load.csv
wc -l ${HOME_PATH}/script/load/data/bulk_load.csv
$DB2_HOME/bin/db2 -tvf ${HOME_PATH}/script/load/sql/load.sql
