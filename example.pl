#!/usr/bin/perl -w

use strict;

use lib './lib';

use Net::DNS::Match;
use Data::Dumper;

my $addr = 'xyz.yahoo.com';

my $match = Net::DNS::Match->new();
$match->add([
    'yahoo.com',
    'google.com',
    'www.facebook.com',
 ]);

warn Dumper($match->match($addr));
