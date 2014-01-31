use utf8;

package IBM::MDM::LogAnalyzer::Schema::Result::AnalyticsAvg;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

__PACKAGE__->table('analyticsavg');
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    "SELECT analytics_avg FROM analytics_avg(?,?,?)");
__PACKAGE__->add_columns(
    'analytics_avg' => {
        data_type => 'float',
    },
);

1;
