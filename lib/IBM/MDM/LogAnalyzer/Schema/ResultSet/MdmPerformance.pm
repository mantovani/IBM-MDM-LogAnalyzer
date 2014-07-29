package IBM::MDM::LogAnalyzer::Schema::ResultSet::MdmPerformance;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

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

sub json_real_time {
    my ( $self, $name, $run, $operation, $timestamp ) = @_;
    [
        map {
            {
                x => int( ( $_->date->epoch + 10800 ) * 1000 ),
                y => int( $_->get_column('avg_delay') )
            }
          } $self->search(
            {
                name      => $name,
                run       => $run,
                operation => $operation,
                date      => \[
'BETWEEN TIMESTAMP(\'1970-01-01\', \'00:00:00\') + ? SECONDS AND TIMESTAMP(\'1970-01-01\', \'00:00:00\') + ? SECONDS',
                    [ plain_value => $timestamp ],
                    [ plain_value => $timestamp + 60]
                ]
            },
            {
                select =>
                  [ 'name', 'run', 'operation', 'date', { avg => 'delay' } ],
                as => [ 'name', 'run', 'operation', 'date', 'avg_delay' ],
                group_by => [qw/name run operation date/],
                order_by => { -asc => 'date' },

            }
          )->all
    ];
}

1;
