package IBM::MDM::LogAnalyzer::Controller::Analyzer;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

IBM::MDM::LogAnalyzer::Controller::Analyzer - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('/') : PathPart('analyzer') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{parser}  = $c->model('DB::Analyzer');
    $c->stash->{db_json} = $c->model('DB::AnalyticsAvg');
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
}

sub upload : Chained('base') : PathPart('upload') : Args(0) {
    my ( $self, $c ) = @_;
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
        if ( my $upload = $c->request->upload('log') ) {
            $c->stash->{parser}->parser( $upload, $c->request->parameters );
        }
    }
}

sub response : Chained('base') : PathPart('response') : Args(3) {
    my ( $self, $c, $name, $run, $operation ) = @_;
    $c->stash->{data} =
      $c->stash->{db_json}->json_analyzer( $name, $run, $operation );
    $c->forward('View::JSON');
}

sub statics : Chained('base') : PathPart('statics') : Args(2) {
    my ( $self, $c, $name, $operation ) = @_;
    $c->stash->{operation} = $operation;

}

=head1 AUTHOR

Daniel Mantovani

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
