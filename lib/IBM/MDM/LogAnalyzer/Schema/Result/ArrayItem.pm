use utf8;
package IBM::MDM::LogAnalyzer::Schema::Result::ArrayItem;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IBM::MDM::LogAnalyzer::Schema::Result::ArrayItem

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

=head1 TABLE: C<array_item>

=cut

__PACKAGE__->table("array_item");

=head1 ACCESSORS

=head2 avg

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns("avg", { data_type => "double precision", is_nullable => 1 });


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2014-01-31 17:18:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MdwD3kjodmS0+63+nWGAgA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
