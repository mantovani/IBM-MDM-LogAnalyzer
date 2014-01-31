use strict;
use warnings;

use IBM::MDM::LogAnalyzer;

my $app = IBM::MDM::LogAnalyzer->apply_default_middlewares(IBM::MDM::LogAnalyzer->psgi_app);
$app;

