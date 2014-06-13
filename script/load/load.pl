#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    if ( @ARGV < 2 ) {
		print "$0 RunName Run\n";
    }
}

$| = 1;

my $date;
while ( my $line = <STDIN> ) {
    chomp $line;
    if ( $line =~ m{(\d{4}\-\d{2}\-\d{2}\s+\d+:\d+:\d+)} ) {
        $date = $1;
        next;
    }
    if ( $line =~
m{\d+\s(\w+)\s+:\s+\w+_CONTROLLER\s+@\s+CONTROLLER\s+:\s+:\s+\d+\s+:\s+(\d+)\s+:\s+:\s+SUCCESS}
      )
    {
        my ( $op, $delay ) = ( $1, $2 );
        print join ",", $ARGV[0], $ARGV[1], $op, $delay, $date;
        print "\n";
    }
}
