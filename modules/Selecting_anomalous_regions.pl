#!/usr/bin/perl
#This module selects the putative anomalous regions and provides the respective coordinates.
use strict;
use Statistics::Descriptive;

#Reads the EntMax_result.txt file  generated in the previous module.
my $Ent_max_file = "MaxEnt_result.txt";
chomp($Ent_max_file);

#Reads the coordinates file generated in the previous module.
my $coordinates = "coordinates.txt";
chomp($coordinates);

open(EM, $Ent_max_file) || die "Could not open file  $Ent_max_file";

open(RESULT, ">PredictedAnomalousRegions") || die "Could not open file  $Ent_max_file";

my $header_EM = <EM>;
my %Ent_Max;
my @entropy_values;

#Reading and selection entropies.
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
    push(@entropy_values, $entropy);
    
    $Ent_Max{$number_name}=$entropy; 
    
}

#Calculating third quantile.
my $stat = Statistics::Descriptive::Full->new();
$stat->add_data(@entropy_values);
my $median= $stat->median(@entropy_values);
my $third_quartil= $stat->quantile(3);

#Selecting the results and coordinates
print RESULT "Regions\tMaximum entropy\tCoordinates\n";

foreach my $key (sort{$a <=> $b} keys(%Ent_Max)){
    
    if($Ent_Max{$key} >= $third_quartil){
	my $name_region = "Region_" . $key;
	  	
	open(COORD, $coordinates) || die "Could not open file  $coordinates";	
	my $header_coord = <COORD>;
	
	while(my $entry_2=<COORD>){
	    chomp($entry_2);
	    my ($region, $coord)=split(/\=/, $entry_2);
	    
	    if($region=~m/$name_region\s/){
		
   		print RESULT "Region_$key\t$Ent_Max{$key}\t$coord\n";
	    }
	}
   close(COORD); 
    }
	
}

close(EM);
close(RESULT);

