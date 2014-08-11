package IBM::MDM::LogAnalyzer::Schema::ResultSet::MdmPerformance;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use constant BLOCK => 100;

use Data::Dumper;

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

sub list_runs {
    my ( $self, $name ) = @_;
    [
        map { $_->run } $self->search(
            { name => $name },
            {
                columns  => [qw/run/],
                group_by => [qw/name run/],
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

sub list_operations_by_run {
    my ( $self, $name, $run ) = @_;
    [
        map { $_->operation } $self->search(
            { name => $name, run => $run },
            {
                columns  => [qw/operation/],
                group_by => [qw/name operation/],
            }
        )->all
    ];
}

sub list_range {
    return [ map { BLOCK * $_ } 1 .. 10 ];
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
                    [ plain_value => $timestamp + 60 ]
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

sub json_transaction_avg {
    my ( $self, $name, $operation ) = @_;
    [
        map {
            [
                $_->get_column('name') . ':' . $_->get_column('run'),
                int( $_->get_column('average') )
            ]
          } $self->search(
            {
                name      => $name,
                operation => $operation
            },
            {
                select => [ 'name', { avg => 'delay' }, 'run' ],
                as       => [ 'name', 'average', 'run' ],
                group_by => [qw/name operation run/],
            }
          )->all
    ];
}

sub total_operations_by_run {
    my ( $self, $name, $run, $operation ) = @_;
    return [
        map { $_->get_column('total') } $self->search(
            {
                name      => $name,
                run       => $run,
                operation => $operation
            },
            {
                select => [ { count => '*' } ],
                as     => ['total']
            }
        )->all
    ];
}

sub report_transaction {
    my ( $self, $name, $run ) = @_;
    my $stack = {};
    my $operations = $self->list_operations_by_run( $name, $run );
    foreach my $operation ( @{$operations} ) {
        my $count = $self->total_operations_by_run( $name, $run, $operation );
        my $last_range;
        foreach my $range ( @{ $self->list_range } ) {
            $last_range = $range;
            push @{ $stack->{$operation} }, map {
                {
                    total   => $_->get_column('total'),
                    percent => sprintf( "%.2f",
                        $_->get_column('total') * 100 / $count->[0] )
                }
              } $self->search(
                {
                    name      => $name,
                    run       => $run,
                    operation => $operation,
                    delay     => \[
                            "BETWEEN "
                          . ( $range - BLOCK ) . " AND "
                          . ( $range - 1 )
                    ]
                },
                {
                    select => [ { count => '*' } ],
                    as     => [qw/total/],
                }
              )->all;
        }

        push @{ $stack->{$operation} }, map {
            {
                total   => $_->get_column('total'),
                percent => sprintf(
                    "%.2f", $_->get_column('total') * 100 / $count->[0]
                )
            }
          } $self->search(
            {
                name      => $name,
                run       => $run,
                operation => $operation,
                delay     => { '>=', $last_range }
            },
            {
                select => [ { count => '*' } ],
                as     => [qw/total/],
            }
          )->all;

    }
    return $stack;
}

1;
