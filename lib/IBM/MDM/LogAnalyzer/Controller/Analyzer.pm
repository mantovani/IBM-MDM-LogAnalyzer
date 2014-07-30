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
    $c->stash->{mdm_analyzer} = $c->model('DB::MdmPerformance');
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
}

sub listoperations : Chained('base') : PathPart('listoperations') : Args(1) {
    my ( $self, $c, $name ) = @_;
    $c->stash->{test_name} = $name;
}

sub statistics : Chained('base') : PathPart('statistics') : Args(2) {
    my ( $self, $c, $name, $operation ) = @_;
    $c->stash->{test_name} = $name;
    $c->stash->{operation} = $operation;
}

sub json_statiscs : Chained('base') : PathPart('json_statistics') : Args(2) {
    my ( $self, $c, $name, $operation ) = @_;
    $c->stash->{data} =
      $c->stash->{mdm_analyzer}->json_tps_avg( $name, $operation );
    $c->forward('View::JSON');
}

sub online_statistics : Chained('base') : PathPart('online_statistics') : Args(3) {
    my ( $self, $c, $name, $operation, $run ) = @_;
    $c->stash->{test_name} = $name;
    $c->stash->{operation} = $operation;
    $c->stash->{run}       = $run;
}

sub json_online_statistics : Chained('base') :
  PathPart('json_online_statistics') : Args(4) {
    my ( $self, $c, $name, $operation, $run, $timestamp ) = @_;
    $c->stash->{data} =
      $c->stash->{mdm_analyzer}
      ->json_real_time( $name, $run, $operation, $timestamp );
    $c->forward('View::JSON');
}

=head1 AUTHOR

Daniel Mantovani

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
