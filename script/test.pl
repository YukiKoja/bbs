#!/usr/bin/perl

use strict;
use DBI;

my $DB_NAME = "hoge";
my $DB_HOST = "127.0.0.1";
my $DB_USER = "koja";
my $DB_PASSWD = "yuki";

my $dbh = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST", $DB_USER, $DB_PASSWD)
    or die "$!\n Error: failed to connect to DB.\n";
my $sth = $dbh->prepare("SELECT * FROM test ");
$sth->execute();

while (my $href = $sth->fetchrow_hashref) {
    
    print $href->{name},"\n";
    print $href->{comment},"\n";
    print $href->{create_timestamp},"\n";

}

$dbh->disconnect;
