use utf8;
package IBM::MDM::LogAnalyzer::Schema::Result::Analyzer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IBM::MDM::LogAnalyzer::Schema::Result::Analyzer

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<analyzer>

=cut

__PACKAGE__->table("analyzer");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'analyzer_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 run

  data_type: 'bigint'
  is_nullable: 1

=head2 operation

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 delay

  data_type: 'double precision'
  is_nullable: 1

=head2 date

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "analyzer_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "run",
  { data_type => "bigint", is_nullable => 1 },
  "operation",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "delay",
  { data_type => "double precision", is_nullable => 1 },
  "date",
  { data_type => "timestamp", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2014-02-25 17:44:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P3pVDndVNvR5be9/EsJdXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
