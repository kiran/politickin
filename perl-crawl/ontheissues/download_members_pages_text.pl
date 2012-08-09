#!/usr/bin/perl
use strict;
use warnings;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new(onerror => undef);
my $urlPrefix = "http://www.ontheissues.org/Senate/";
open (my $cmembers, "<", "fixed_member_page_urls.tsv") or die "$!: Couldn't open members database";

foreach my $member (<$cmembers>){
	my @member_array = split("\t", $member);
	my $name = $member_array[0];
	my $url = $member_array[1];

	$mech->get($url);

	print "Downloading text for $name from $url";

	open(my $member_page, ">", $name . ".txt") or die "$!: Couldn't open $name for writing";
	$mech->dump_text($member_page);
}
