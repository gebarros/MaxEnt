#/usr/bin/perl
#This module edits and prepare the maximum entropy result to display the signature in the next module.
use strict;

#Reads the EntMax_result.txt file  generated in the previous module.
my $Ent_max_file = "MaxEnt_result.txt";
chomp($Ent_max_file);

open(EM, $Ent_max_file) || die "Could not open file  $Ent_max_file";

my $header_EM = <EM>;
my %Ent_Max;

#Preparing the file list_EM.csv.
while(my $entry=<EM>){
    chomp($entry);
 $entry=~s/\"//g;
my @names = split(/.csv/, $entry);

    my $name = $names[0];
    $name=~s/^\d+\s+//;
    $name=~m/Matrix\_Region\_.+\_(\d\d*)/;
    my $number_name = $1;
   
    my $entropy = $names[1];
    $entropy=~s/^\s+//;
    $entropy=~s/\./,/;
    
    $Ent_Max{$number_name}=$entropy; 
 
}

open(ENTMAX, ">list_EM.csv") || die "Could not create file listEM.csv";
foreach my $key (sort{$a <=> $b} keys(%Ent_Max)){
   print ENTMAX "$Ent_Max{$key}\n";
}

close(EM);
close(ENTMAX);
