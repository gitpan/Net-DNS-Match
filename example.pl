#!/usr/bin/perl -w

use strict;

use lib './lib';

use Net::DNS::Match;
use Data::Dumper;

my $addr = 'montreal.qc.ca.undernet.org';

my $match = Net::DNS::Match->new();
$match->add([
    'xyz.yahoo.com',
    'google.com',
    'www.facebook.com',
    'undernet.org',
 ]);
 
 die ::Dumper($match->match($addr));
