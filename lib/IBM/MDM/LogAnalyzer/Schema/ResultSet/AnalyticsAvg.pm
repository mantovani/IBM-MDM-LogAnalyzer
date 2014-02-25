package IBM::MDM::LogAnalyzer::Schema::ResultSet::AnalyticsAvg;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub json_analyzer {
    my ( $self, $name, $run, $operation ) = @_;
    my $rs = $self->search( {}, { bind => [ $name, $operation, $run ] } );
    return [ $rs->get_column('analytics_avg')->all ];
}
1;
