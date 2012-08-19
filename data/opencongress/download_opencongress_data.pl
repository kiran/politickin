#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

my $url_prefix = "http://api.opencongress.org/people?";
my $dir_name = "opencongress";

$|=1;	#turn off stdout output buffering
local $/ = "\r";	#Set line ending to osx's \r 

open (my $member_details, "<", "sunlight_legislators_all.csv") or die "$!: Couldn't open members database";
<$member_details>; #skip the header line

while  (my $member = <$member_details>){
	chomp $member;
	my @member_array = split(",", $member);
	#opencongress urls are case sensitive for names!
	my $first_name = $member_array[1];
	my $last_name = $member_array[3];
	my $combined_name = $first_name . " " .$last_name;

	my $parameters = "first_name=$first_name&last_name=$last_name";
	my $url = $url_prefix . $parameters;

	print "Downloading data for $first_name $last_name from $url\n";
	
	my $page = get $url;
	open(my $member_page, ">", $dir_name."/". $combined_name . ".xml") or die "$!: Couldn't open $dir_name $combined_name.json for writing";
	print $member_page $page;
}
