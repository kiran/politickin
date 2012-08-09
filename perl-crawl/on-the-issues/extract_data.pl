#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use JSON;

# Declare the subroutines
sub trim($);
sub ltrim($);
sub rtrim($);

my @issues = ("Foreign Policy","Gun Control","Budget & Economy","Education","Homeland Security","Crime","Government Reform","Health Care","War & Peace","Drugs","Tax Reform","Abortion","Free Trade","Civil Rights","Social Security","Families & Children","Immigration","Jobs","Welfare & Poverty","Corporations","Energy & Oil","Environment","Technology & Infrastructure","Principles & Values");

my $dir = 'data';
opendir(DIR, $dir) or die $!;
open (my $outputfile, ">", "outputfile_test.tsv") or die "$!: Couldn't open output file";

while (my $filename = readdir(DIR)) {
	# Skip non .txt files
    next if !($filename =~ m/\.txt$/);
	my $name = substr($filename, 0, rindex($filename, '.'));

	open (my $content, "<", $dir."/".$filename) or die "$!: Couldn't open members database";

	my %all;
	foreach my $member (<$content>){
		$member =~ s/$name on Abortion(.*)?VoteMatch Responses//;
		my $main_chunk = "Abortion " . $1;
		$main_chunk =~ s/($name on )/\n/g;
		$main_chunk =~ s/Click here for (.*)? on (.*)? OR (.*)? on \2./\n/g;
		$main_chunk =~ s/\.\s(\(.*?\))/$1\n/g;

		#print $main_chunk;
		my @data = split("\n", $main_chunk);

		my $current_key = "";
		my %subtopic;
		my @voted;
		my @rated;
		my @quoted;
		my @factcheck;
		my @sponsored;
		for my $line (@data){
			chomp $line;
			$line = rtrim($line);
			if ($line eq ""){
				$all{$current_key}{"voted"} = [@voted];
				$all{$current_key}{"rated"} = [@rated];
				$all{$current_key}{"quoted"} = [@quoted];
				$all{$current_key}{"factcheck"} = [@factcheck];
				$all{$current_key}{"sponsored"} = [@sponsored];
			}
			if (substr($line,0,1) ne " "){
				chomp($line);
				$current_key = $line;
				undef @voted;
				undef @rated;
				undef @quoted;
				undef @factcheck;
				undef @sponsored;
			} else {
				$line = ltrim($line);
				if ($line =~ /Voted/){
					push(@voted, $line);
				} 
				elsif ($line =~ /Rated/){
					push(@rated, $line);
				} 
				elsif ($line =~ /FactCheck/){
					push(@factcheck, $line);
				} 
				elsif ($line =~ /Sponsored/){
					push(@sponsored, $line);
				}
				else {
					push(@quoted, $line);
				}
			}

		}
		
		#instead of dumping everything as one json blob, iterate over the hash using a 
		#standard list of issues and dump those json fields as a tab separated file
		print $outputfile "$name\t";
		foreach my $issue (@issues){
			my $utf8_encoded_json_text = encode_json \%{$all{$issue}};
			print $outputfile "$utf8_encoded_json_text\t";
		}
		print $outputfile "\n";
	}
}

closedir(DIR);

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
# Left trim function to remove leading whitespace
sub ltrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	return $string;
}
# Right trim function to remove trailing whitespace
sub rtrim($)
{
	my $string = shift;
	$string =~ s/\s+$//;
	return $string;
}

