#!/usr/bin/perl
use strict;
use warnings;

open(my $urls_list, "<", "member_page_urls.tsv") or die "$!: Cannot open members urls list";
open(my $fixed_urls, ">", "fixed_member_page_urls.tsv") or die "$!: Cannot create fixed members urls list";

my $default_prefix = "http://www.ontheissues.org/";

for my $line (<$urls_list>){
	chomp $line;
	my @name_url = reverse(split("\t", $line));
	my $url = $name_url[1];
	if($url =~ /(http).*/){
		print $fixed_urls "$name_url[0]\t$name_url[1]\n";
	} else {
		my $new_url = $default_prefix . $name_url[1];
		print $fixed_urls "$name_url[0]\t$new_url\n";
	}
}