#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst;    # Complain loudly if you don't have
                                  # Catalyst::Devel installed or haven't said
                                  # 'make dist' to create a standalone tarball.

name 'IBM-MDM-LogAnalyzer';
all_from 'lib/IBM/MDM/LogAnalyzer.pm';

requires 'Catalyst::Runtime' => '5.90030';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::ScriptRunner';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Config::General';
requires 'Catalyst::View::TT';
requires 'Catalyst::Model::DBIC::Schema';
requires 'JSON';
requires 'JSON::Syck';
requires 'Catalyst::View::JSON';
requires 'MooseX::NonMoose';
requires 'Catalyst::Action::RenderView';
requires 'Data::Dumper';
requires 'MooseX::MarkAsMethods';
requires 'Moose';
requires 'DBD::DB2';
requires 'DateTime::Format::Strptime';
requires 'namespace::autoclean';
requires
  'Config::General';  # This should reflect the config file format you've chosen
                      # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
