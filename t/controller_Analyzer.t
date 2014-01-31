use strict;
use warnings;
use Test::More;


use Catalyst::Test 'IBM::MDM::LogAnalyzer';
use IBM::MDM::LogAnalyzer::Controller::Analyzer;

ok( request('/analyzer')->is_success, 'Request should succeed' );
done_testing();
