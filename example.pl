#!/usr/bin/perl -w

use strict;
use warnings;

use lib './lib';

use Net::DNS::Match;
use Data::Dumper;

my $addr = 'montreal.qc.ca.undernet.org';
#my $addr = 'zzz.yahoo.com';

my $match = Net::DNS::Match->new();
$match->add([
    'abc.yahoo.com',
    'google.com',
    'ca.undernet.org',
    'undernet.org',
    'test.ca.undernet.org',
    'www.facebook.com',
    'ztest2.ca.undernet.org',
    'aaaaol.com',
    'yahoo.com', 
    'zmg.yahoo.com',
    
    
]);
 
die ::Dumper($match->match($addr));