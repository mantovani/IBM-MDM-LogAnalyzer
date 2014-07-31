package IBM::MDM::LogAnalyzer::Schema::ResultSet::MdmPerformance;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use constant BLOCK => 10;

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

sub list_runs {
    my ( $self, $name, $operation ) = @_;
    [
        map { $_->run } $self->search(
            {
                name      => $name,
                operation => $operation
            },
            {
                columns  => [qw/run/],
                group_by => [qw/name operation run/],
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

sub _min_max_transaction_run {
    my ( $self, $name, $operation, $run ) = @_;
    my @result = $self->search(
        {
            name      => $name,
            operation => $operation,
            run       => $run
        },
        {
            select =>
              [ { max => 'delay' }, { min => 'delay' }, { count => '*' } ],
            as       => [ 'max', 'min', 'total' ],
            group_by => [qw/name operation run/],
        }
    )->all;
    return {
        min   => $result[0]->get_column('min'),
        max   => $result[0]->get_column('max'),
        total => $result[0]->get_column('total'),
    };
}

sub report_transaction {
    my ( $self, $name, $operation ) = @_;
    my $runs = $self->list_runs( $name, $operation );
    my $stack = {};
    foreach my $run ( @{$runs} ) {
        my $values = $self->_min_max_transaction_run( $name, $operation, $run );
        print Dumper $values;
        my $diff  = $values->{max} - $values->{min};
        my $total = $values->{total};
        my $block = int $diff / BLOCK;
        for my $unit ( 0 .. BLOCK ) {
            push @{ $stack->{$run} }, map {
                {
                    count   => $_->get_column('total'),
                    total   => $total,
                    percent => $_->get_column('total') * 100 / $total,
                    between => [
                        ( $unit * $block ) ? ( $unit * $block )
                        : $values->{min},
                        ( $block + ( $block * $unit ) - 1 ) > $values->{max}
                        ? $values->{max}
                        : $block + ( $block * $unit ) - 1
                    ]
                }
              } $self->search(
                {
                    name      => $name,
                    operation => $operation,
                    run       => $run,
                    delay     => {
                        -between => [
                            ( $unit * $block ) ? ( $unit * $block )
                            : $values->{min},
                            ( $block + ( $block * $unit ) - 1 ) > $values->{max}
                            ? $values->{max}
                            : $block + ( $block * $unit ) - 1
                        ]
                    },
                },
                {
                    select => [ 'name', 'operation', 'run', { count => '*' } ],
                    as       => [qw/name operation run total/],
                    group_by => [qw/name operation run/],
                }
              )->all;
        }
    }
    return $stack;
}

1;
