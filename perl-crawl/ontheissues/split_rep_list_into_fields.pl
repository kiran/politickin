#!/usr/bin/perl
use strict;
use warnings;

open(my $crep_with_linenumbers, "<", "selected_members_with_linenumbers.tsv") or die "cannot open < input.txt: $!";
open(my $crep_split, ">", "selected_members.tsv") or die "$!: Could not open file to write";

for my $rep (<$crep_with_linenumbers>){
	my @fields = split ("\t", $rep);
	my $id = $fields[0];
	my $fullname = $fields[1];
	$fields[2] =~ /(.*)?\s+(Representative|(Jr|Sr)*\s+Senator)\s+\((.*)\)/;
	my $affiliation = $1;
	my $title = $2;
	my $constituency = $4;
	print $crep_split "$id\t$fullname\t$affiliation\t$title\t$constituency\n"
}