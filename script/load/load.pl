#!/usr/bin/perl

use strict;
use warnings;

use DateTime;
use DateTime::Format::Strptime;

use constant RUN  => 14;
use constant NAME => 'R57';
use constant CONFIG =>
  '/home/hadoop/apps/IBM-MDM-LogAnalyzer/script/load/config';
use constant ZERO => 0;

$| = 1;

{
    my ( $date, $timestamp, $count );
    my $higher_ts = ZERO;
    my $buff      = {};

    my $parser =
      DateTime::Format::Strptime->new( pattern => '%Y-%m-%d %H:%M:%S' );

    my $last_insert = start();

    while ( my $line = <STDIN> ) {
        $count++;
        chomp $line;
        if ( $line =~ m{(\d{4}\-\d{2}\-\d{2}\s+\d+:\d+:\d+)} ) {
            $date      = $1;
            $timestamp = $parser->parse_datetime($date)->epoch;
            if ( $timestamp > $higher_ts ) { $higher_ts = $timestamp }
            next;
        }
        if ( $timestamp > $last_insert ) {
            if ( $line =~
m{\d+\s(\w+)\s+:\s+\w+_CONTROLLER\s+@\s+CONTROLLER\s+:\s+:\s+\d+\s+:\s+(\d+)\s+:\s+:\s+SUCCESS}
              )
            {
                my ( $op, $delay ) = ( $1, $2 );
                $buff->{$op}->{$date}->{ $delay / 1000000 } = 1;
            }
        }
    }
    write_persistent($higher_ts);
    dump_buff($buff);
}

sub dump_buff {
    my $buff = shift;
    foreach my $op ( keys %{$buff} ) {
        foreach my $date ( keys %{ $buff->{$op} } ) {
            foreach my $delay ( keys %{ $buff->{$op}->{$date} } ) {
                print join ",", NAME, RUN, $op, $delay, $date;
                print "\n";
            }
        }
    }
    return 1;
}

sub write_persistent {
    my $timestamp = shift;
    open my $fh, '>', CONFIG or die $!;
    print $fh $timestamp;
    close $fh;
    return 1;
}

sub start {
    if ( !-e CONFIG ) {
        open my $fh, '>', CONFIG or die $!;
        print $fh ZERO;
        close $fh;
    }
    open my $fh, '<', CONFIG or die $!;
    my $config = <$fh>;
    close $fh;
    if ( $config =~ m{(\d+)} ) {
        return $1;
    }
    die "config file with problem";
}
