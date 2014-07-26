use utf8;
package IBM::MDM::LogAnalyzer::Schema::Result::MdmPerformance;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IBM::MDM::LogAnalyzer::Schema::Result::MdmPerformance

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

=head1 TABLE: C<MDM_PERFORMANCE>

=cut

__PACKAGE__->table("MDM_PERFORMANCE");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 run

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 operation

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 delay

  data_type: 'integer'
  is_nullable: 0

=head2 date

  data_type: 'timestamp'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "run",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "operation",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "delay",
  { data_type => "integer", is_nullable => 0 },
  "date",
  { data_type => "timestamp", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-07-25 11:58:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hWL5d1YYtPX/+vPEEoEnSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
