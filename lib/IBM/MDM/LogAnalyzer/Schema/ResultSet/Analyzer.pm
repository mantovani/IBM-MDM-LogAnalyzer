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
            m{\d+\s+(\w+)\s+:\s+\w+_CONTROLLER\s+@\s+CONTROLLER\s+:\s+:\s+(\d+)}
          )
        {
            $self->create(
                {
                    name      => $params->{name},
                    run       => $params->{run},
                    operation => $1,
                    delay     => $2,
                    date      => $date,
                }
            );
        }
    }
    close $output;
    unlink $filename;
    return 1;
}

1;
