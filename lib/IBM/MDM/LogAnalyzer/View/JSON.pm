package IBM::MDM::LogAnalyzer::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

use JSON::XS ();

sub encode_json {
    my ( $self, $c, $data ) = @_;
    my $encoder = JSON::XS->new->allow_nonref;
    $encoder->encode($data);
}

=head1 NAME

IBM::MDM::LogAnalyzer::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<IBM::MDM::LogAnalyzer>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

Daniel Mantovani

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
