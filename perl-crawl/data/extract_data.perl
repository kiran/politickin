#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use JSON;

# Declare the subroutines
sub trim($);
sub ltrim($);
sub rtrim($);


my $dir = '.';
opendir(DIR, $dir) or die $!;
open (my $outputfile, ">", "outputfile.tsv") or die "$!: Couldn't open output file";

while (my $filename = readdir(DIR)) {
    # Use a regular expression to ignore files beginning with a period
    next if !($filename =~ m/\.txt$/);
	my $name = substr($filename, 0, rindex($filename, '.'));

	open (my $content, "<", $filename) or die "$!: Couldn't open members database";

	my %all;
	foreach my $member (<$content>){
		$member =~ s/$name on Abortion(.*)?VoteMatch Responses//;
		my $main_chunk = "Abortion " . $1;
		$main_chunk =~ s/($name on )/\n/g;
		$main_chunk =~ s/Click here for \d+ full quotes on (.*)? OR (.*)? on \1./\n/g;
		$main_chunk =~ s/(\(.*?\))/$1\n/g;

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
		my $utf8_encoded_json_text = encode_json \%all;
		print $outputfile "$name\t$utf8_encoded_json_text\n";	
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

