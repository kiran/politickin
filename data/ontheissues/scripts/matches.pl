#!/usr/bin/perl
use warnings;
use strict;

open (my $downloaded, "<", "datatext") or die "Can't open file 1";
my %downs;
while (my $name = <$downloaded>){
    chomp $name;
    my ($firstname, $lastname) = split (" ", $name);
    $downs{$lastname} += 1;
}

my $c;
foreach my $key (keys %downs){
    if ($downs{$key} > 1){
        print "$key\n";
         $c++;
    }

}

print $c;
#
#open (my $sunlight, "<", "sunlight_legislators_all.csv");
#my %sunlight;
#my $count;
#open (my $notfound, ">", "notfoundindl.txt");
#while (my $sunlight_row = <$sunlight>){
#    chomp $sunlight_row;
#    my @fields = split(",", $sunlight_row);
#    my $name = $fields[1] . " " . $fields[3];
#    if ($downs{$name} == 1){
#        print $name;
#    } else {
#        print $notfound $name . "\n";
#    }
#}
#
#print $count;