package IBM::MDM::LogAnalyzer::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    {
        INCLUDE_PATH => [
            IBM::MDM::LogAnalyzer->path_to( 'root', 'src' ),
            IBM::MDM::LogAnalyzer->path_to( 'root', 'lib' )
        ],
        PRE_PROCESS        => 'config/main',
        WRAPPER            => 'site/wrapper',
        ERROR              => 'error.tt2',
        TIMER              => 0,
        render_die         => 1,
        TEMPLATE_EXTENSION => '.tt',
    }
);

=head1 NAME

IBM::MDM::LogAnalyzer::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<IBM::MDM::LogAnalyzer>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Daniel Mantovani

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

