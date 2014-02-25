package IBM::MDM::LogAnalyzer::Schema::ResultSet::Analyzer;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use IO::Uncompress::Unzip qw/unzip/;
use File::Temp qw/ tempfile /;

sub parser {
    my ( $self, $upload, $params ) = @_;
    my ( $output, $filename ) = tempfile();

    unzip \$upload->slurp => $output or die $!;

    my $date;

    seek $output, 0, 0;
    while ( my $line = <$output> ) {
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
            $self->create(
                {
                    name      => $params->{name},
                    run       => $params->{run},
                    operation => $op,
                    delay     => $delay,
                    date      => $date,
                }
            );
        }
    }
    close $output;
    unlink $filename;
    return 1;
}

sub runs {
    my ( $self, $name, $operation ) = @_;
    [
        map { $_->run } $self->search(
            { name => $name, operation => $operation },
            {
                columns  => [qw/run/],
                group_by => [qw/run/],
            }
        )->all
    ];
}

sub list_names {
    my $self = shift;
    [
        map { $_->name } $self->search(
            {},
            {
                columns  => [qw/name/],
                group_by => [qw/name/],
            }
        )->all
    ];
}

sub list_operations {
    my ( $self, $name ) = @_;
    [
        map { $_->operation } $self->search(
            { name => $name },
            {
                columns  => [qw/operation/],
                group_by => [qw/name operation/],
            }
        )->all
    ];
}
1;
