#!/usr/bin/perl
use warnings;
use strict;
use JSON::XS;

local $/; #set to slurp mode, read entire file in a string


my $dir = 'reps';
opendir(DIR, $dir) or die $!;
open (my $outputfile, ">", "outputfile_test.tsv") or die "$!: Couldn't open output file";

while (my $filename = readdir(DIR)) {
	# Skip non .json files
    next if !($filename =~ m/\.json$/);
	my $name = substr($filename, 0, rindex($filename, '.'));
	my @nameparts = split("_", $name);
	my $fname = $nameparts[0];
	my $lname = $nameparts[1];

	open (my $json_file, "<", $dir."/".$filename) or die "$!:could not open xml file";
	print "Opening $name \n";
	my $JSON = <$json_file>;
	$JSON =~ s/\n//g;
	my $perl_scalar = decode_json $JSON;
	my $hash_ref =  $perl_scalar->[0];

	print $outputfile "$fname\t$lname\t";

	for my $key (keys %$hash_ref){
		my $data = %$hash_ref->{$key};
		if ($key eq "bills_sponsored" || $key eq "earmarks_sponsored"){
			$data = encode_json \@$data;
		}
		if (!defined($data)){
			$data = "";
		}
		print $outputfile "$data\t";
	}
	print $outputfile "\n";
	
}

closedir(DIR);
