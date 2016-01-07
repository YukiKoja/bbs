#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

my $file = "$0";
my $a = basename($file, ".pl");

print $a;
