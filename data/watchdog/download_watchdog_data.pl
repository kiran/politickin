#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

my $url_prefix = "http://www.watchdog.net/p/";
my $dir_name = "watchdog";

$|=1; #turn off stdout output buffering

open (my $member_details, "<", "authoritative_reps.tsv") or die "$!: Couldn't open members database";
while  (my $member = <$member_details>){
	chomp $member;
	my @member_array = split("\t", $member);
	my $first_name = lc($member_array[0]);
	my $last_name = lc($member_array[1]);
	my $combined_name = $first_name . "_" .$last_name;
	my $url = $url_prefix . $combined_name . ".json";
	my $page = get $url;
	my $filename = $dir_name."/".$combined_name. ".json";
	if (-e $filename){
		next; #==continue
	} 
	if(!defined $page){
		print "No info for member $combined_name\n";
	}
	else {
		open(my $member_page, ">", $dir_name."/".$combined_name. ".json") or die "$!: Couldn't open $dir_name $combined_name.json for writing";
		print $member_page $page;	
	}
}
