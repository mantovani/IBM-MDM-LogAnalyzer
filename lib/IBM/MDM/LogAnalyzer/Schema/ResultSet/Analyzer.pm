package IBM::MDM::LogAnalyzer::Schema::ResultSet::Analyzer;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use IO::Uncompress::Unzip qw/unzip/;
use File::Temp qw/ tempfile /;
use IO::Handle;

sub parser {
    my ( $self, $upload, $params ) = @_;

    open my $fh, '<', $upload->tempname or die $!;

    my @data;
    my $date;

    while ( my $line = <$fh> ) {
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
            push @data, [ $params->{name}, $params->{run}, $op, $delay, $date ];
        }

    }

    my $tbname = $self->result_source->name;
    $self->result_source->schema->storage->dbh_do(
        sub {
            my ( $storage, $dbh ) = @_;
            $dbh->do(
"COPY $tbname (name,run,operation,delay,date) FROM STDIN WITH CSV"
            );
            foreach my $item (@data) {
                next if not ref $item;
                my $put_data = join ',', @{$item};
                $put_data .= "\n";
                $dbh->pg_putcopydata($put_data) for @data;
            }
            $dbh->pg_putcopyend;
        }
    );

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
