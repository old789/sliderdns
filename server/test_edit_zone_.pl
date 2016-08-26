#!/usr/bin/perl -w

use strict;
use DNS::ZoneParse;

my $hostname="host.zone.tst";
my $ip="172.16.0.3";
my $dns_dir="./";

&edit_zone();
exit;
