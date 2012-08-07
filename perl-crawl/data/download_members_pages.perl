#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

my $urlPrefix = "http://www.ontheissues.org/Senate/";
open (my $cmembers, "<", "fixed_member_page_urls.tsv") or die "$!: Couldn't open members database";

foreach my $member (<$cmembers>){
	my @member_array = split("\t", $member);
	my $name = $member_array[0];
	my $url = $member_array[1];

	print "Downloading data for $name from $url";
	my $page = get $url;

	open(my $member_page, ">", $name . ".html") or die "$!: Couldn't open $name for writing";
	print $member_page $page;
}
