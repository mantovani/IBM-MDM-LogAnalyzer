package IBM::MDM::LogAnalyzer::Schema::ResultSet::AnalyticsAvg;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub json_analyzer {
    my ( $self, $name, $run, $operation ) = @_;
    my $runs = $self->search(
        {
            name      => $name,
            run       => $run,
            operation => $operation
        },
        {
            select => ['delay::bigint / 100000000000000000.0 '],
            as     => [qw(delay_in_sec)]
        }
    );
    my $rs = $self->search( {}, { bind => [ $name, $operation, $run ] } );
    return [ $rs->get_column('analytics_avg')->all ];
}
1;
