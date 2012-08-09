#!/usr/bin/perl
use warnings;
use strict;
use XML::XML2JSON;
use JSON;

local $/; #set to slurp mode, read entire file in a string



my $dir = 'senators';
opendir(DIR, $dir) or die $!;
open (my $outputfile, ">", "outputfile_test.tsv") or die "$!: Couldn't open output file";

while (my $filename = readdir(DIR)) {
	# Skip non .xml files
    next if !($filename =~ m/\.xml$/);
	my $name = substr($filename, 0, rindex($filename, '.'));
	my @nameparts = split("_", $name);
	my $fname = $nameparts[0];
	my $lname = $nameparts[1];

	open (my $xmlfile, "<", $dir."/".$filename) or die "$!:could not open xml file";
	print "Opening $name \n";
	my $xmldata = <$xmlfile>;
	chomp $xmldata;
	$xmldata =~ s/\stype=\"\w+\"//g;
	$xmldata =~ s/\snil=\"\w+\"//g;
	$xmldata =~ s/<\?xml version="1.0" encoding="UTF-8"\?>//g;
	$xmldata =~ s/<hash>//g;
	$xmldata =~ s/<\/hash>//g;
	$xmldata =~ s/<total-pages>\d+<\/total-pages>//g;
	$xmldata =~ s/<people>//g;
	$xmldata =~ s/<\/people>//g;
	$xmldata =~ s/\n//g;
	$xmldata =~ s/\t//g;

	my $XML2JSON = XML::XML2JSON->new(module => "JSON::XS", content_key => "value");

	my $Obj = $XML2JSON->xml2obj($xmldata);
	$XML2JSON->sanitize($Obj);
	my $JSON = $XML2JSON->obj2json($Obj);
	$JSON =~ s/:\{"value":(\".*?\")\}/:$1/g;
	$JSON =~ s/\{\}/\"\"/g;

	my $perl_scalar = decode_json $JSON;

	print $outputfile "$fname\t$lname\t" . encode_json($perl_scalar->{"person"}) . "\n";
}

closedir(DIR);
