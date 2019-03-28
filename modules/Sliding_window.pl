#!/usr/bin/perl -w
# This module splits the genome into how many parts the user wants, calculates the frequency of the one/two/three nucleotides to each part and
#stores into the adjacency matrix.
# To each execution create one directory per genome.
#Outputs: files of each genome substring (.fasta), one coordinates file (.txt) and the adjancecy matrices (.csv).

use strict;
use POSIX;
use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

#Giving the mandatory informations. 
my $help = 0 ; #Calls help for code execution options.
my $infile = ''; #Receives the file name of fasta sequence.
my $window_size = ''; #Receives the window size that user wants.
my $ID_sequence = ''; #Receives the identification of the sequence that will be used in the output file name. 
my $n_nucleotides = ''; #Receives the number of nucleotides that user wants to see the frequency.
my $start_coord_user = '';

#Openning the get options.
GetOptions ('h' => \$help ,'f=s' => \$infile , 'id=s' => \$ID_sequence, 'w=i' => \$window_size, 'n=i' => \$n_nucleotides, 'c=i' => \$start_coord_user) or die "Error in getting options\n";

if ($help || !($infile && $ID_sequence && $window_size && $n_nucleotides && $start_coord_user)) {die "\
$0:\
This program processes the fasta sequence to be analyzed by maximum entropy.\ 

Parameters:\
-h :Shows this help.\
-f :File name of in the fasta format (Mandatory).\
-w : Window size (base pairs number).\
-id :Identification of the sequence (Mandatory).\
-n : Number of nucleotides that user wants to see the frequency.\
-c : Start coordinate to processing.\
\n";
       
}
################################################################################################################
#1- Splits the genomes into how many parts the user wants and get the coordinate.

#Reads the sequence, removes the header and counts the length.
my $seqio = Bio::SeqIO->new('-file' => $infile, '-format' => 'fasta');
my $seqobj = $seqio->next_seq;
my $id = $seqobj->display_id;
my $len = $seqobj->length;
my $seq = $seqobj->seq;
$seq = uc($seq);

my $number_part_previous = $len/$window_size; #Obtaining the number parts of sub-sequences.
my $number_part = ceil($number_part_previous); #Rounding numbers.

#Splitting the genome and generating one file for each part and the respective coordinates.

if($start_coord_user == "1"){
    
    my $start = 0;
    my $end = $window_size;
    
   open(COORD, ">coordinates.txt") || die "Could not generate the output coordinates.\n";
    
    print COORD "Length Complete Genome: $len bases|Window size: $window_size\n";
    
    for (my $file = 1 ; $file <= $number_part ; $file++){
	my $sequence_part = "";
	  open(FASTA, ">Region_$ID_sequence\_$file.fasta") || die "Could not generate the output file.\n";
	
	$sequence_part = substr($seq , $start, $end);
	
	my $length_subseq = length ($sequence_part);
	my $coord_start = $start +1;
	my $coord_end = $start + $length_subseq;
	
	print FASTA ">region_$id$file|$length_subseq|$coord_start..$coord_end\n$sequence_part\n";
	
	print COORD "Region_$file = $coord_start..$coord_end\n" ;

	close (FASTA);
	
	$start += $window_size;
	
    }
    
    close (COORD);
}


if($start_coord_user != "1"){
    my $start = $start_coord_user - 1;
    my $end_coord = ($start_coord_user + $window_size)-1;
    my $coord_start_to_print = '';
    my $coord_end_to_print = '';
    my $diff = 0;
    
    open(COORD, ">coordinates.txt") || die "Could not generate the output coordinates.\n";
    
    print COORD "Length Complete Genome: $len bases|Window size: $window_size\n";
    
     
    for (my $file = 1 ; $file <= $number_part ; $file++){
	my $sequence_part = "";
	 open(FASTA, ">Region_$ID_sequence\_$file.fasta") || die "Could not generate the output file.\n";
	
	if(($start_coord_user <= $len)&&($end_coord <= $len)){
		$sequence_part = substr($seq, $start, $window_size);
		
		my $length_subseq = length ($sequence_part);
		$coord_start_to_print = $start +1;
		$coord_end_to_print = $start + $length_subseq;

		print FASTA ">region_$id$file|$length_subseq|$coord_start_to_print..$coord_end_to_print\n$sequence_part\n";
	        print COORD "Region_$file = $coord_start_to_print..$coord_end_to_print\n" ;

	    }
	
	if(($start_coord_user <= $len)&&($end_coord > $len)){
	    $diff = $end_coord - $len ;
        
	    my $final_part_seq = $diff + 1;
	    
	   my $subseq_1 = substr($seq, $start, $len);
	   my $subseq_2 = substr($seq, 0, $diff);

	    $sequence_part = $subseq_1.$subseq_2;

	    my $length_subseq = length ($sequence_part);
	    $coord_start_to_print = $start +1;
	    $coord_end_to_print = $diff;
		
	    print FASTA ">region_$id$file|$length_subseq|$coord_start_to_print..$coord_end_to_print\n$sequence_part\n";
	    print COORD "Region_$file = $coord_start_to_print..$coord_end_to_print\n" ;			
		  	    
	}

	if(($start_coord_user > $len)&&($end_coord > $len)){
	    $diff = $end_coord - $len ;
	    my $start_from_begin = $start - $len;

	    $sequence_part = substr($seq, $start_from_begin, $window_size);
	  
            my $length_subseq = length ($sequence_part);
	    $coord_start_to_print = $start_from_begin +1;
	    $coord_end_to_print =  $start_from_begin + $length_subseq;
				
	    print FASTA ">region_$id$file|$length_subseq|$coord_start_to_print..$coord_end_to_print\n$sequence_part\n";
	    print COORD "Region_$file = $coord_start_to_print..$coord_end_to_print\n" ;	
	    
	}

	 close (FASTA);
	
	$start += $window_size;
	$start_coord_user += $window_size;
	$end_coord = ($start_coord_user + $window_size)-1;

	  
    }
    close (COORD);
    
}

 ################################################################################################################
 #2-Catches each substring generated by the before step and applies the sliding window. 
 my $name_files = `ls Region*`;
 my @file = split (/\n/, $name_files);

 foreach my $file (@file){

     my $infile2 = $file; #Receives the file name of fasta sequence.

     $file =~s/\.fasta// ; #Receives the identification of the sequence that will be used in the output file name.
    
 #Creating output file.
    
     open(RESULT , ">Matrix_$file.csv") or die ("Could not open the output file.\n");
    
 #Reads the sequence, removes the header and counts the length.
     my $seqio2 = Bio::SeqIO->new('-file' => $infile2, '-format' => 'fasta');
     my $seqobj2 = $seqio2->next_seq;
     my $id2 = $seqobj2->display_id;
     my $len2 = $seqobj2->length;
     my $seq2 = $seqobj2->seq;
    
     my %sliding ; #Declaring the hash.
     my $win_size = $n_nucleotides * 2; #Obtaining the window size.
 
 #Sliding window.
     for (my $i = 1 ; $i <= $len2 -($win_size - 1); $i++){
        	my $window = $seqobj2->subseq($i,$i+($win_size - 1));
        	
 	if (exists ($sliding{$window})){
 	    $sliding{$window} += 1; 
	    
 	}
 	else {
 	    $sliding{$window} = 1;  
 	}

     }    
 ###############################################################################################################################   
 #3-Printing adjacency matrix for each part. 
     my $n = $n_nucleotides ; #Exponential to create the table.
     my $matrix_length = 4 ** $n ; #Matrix size to be created.
     my @rows_matrix = ();  #Declaring array that will store the matrix rows.
    
     if($n_nucleotides == 1){ 
 	my @base1 = ("A" , "C" , "G" , "T");
 	my $bases = "";
	
 	for (my $i=0; $i < 4; $i++){
 	    $bases = $base1[$i];
 	    push (@rows_matrix, $bases);
	    
 	   }
     }
     if($n_nucleotides == 2){
 	my @base1 = ("A" , "C" , "G" , "T");
 	my @base2 = ("A" , "C" , "G" , "T");
 	my $bases = "";
	
 	for (my $i=0; $i < 4; $i++){
 	    $bases = $base1[$i] . $base2[0];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[1];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[2];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[3];
 	    push (@rows_matrix, $bases);
	    
 	}
     }
     if($n_nucleotides == 3){
 	my @base1 = ("A" , "C" , "G" , "T");
 	my @base2 = ("A" , "C" , "G" , "T");
 	my @base3 = ("A" , "C" , "G" , "T");
 	my $bases = "";
	
 	for (my $i=0; $i < 4; $i++){
 	    $bases = $base1[$i] . $base2[0] . $base3[0];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[0] . $base3[1];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[0] . $base3[2];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[0] . $base3[3];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[1] . $base3[0];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[1] . $base3[1];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[1] . $base3[2];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[1] . $base3[3];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[2] . $base3[0];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[2] . $base3[1];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[2] . $base3[2];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[2] . $base3[3];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[3] . $base3[0];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[3] . $base3[1];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[3] . $base3[2];
 	    push (@rows_matrix, $bases);
	    
 	    $bases = $base1[$i] . $base2[3] . $base3[3];
 	    push (@rows_matrix, $bases);
	    
 	}
     }
     my @col_matrix = @rows_matrix;
    
     for (my $i = 0; $i < $matrix_length; $i++){
     	my $cell1 = $rows_matrix[$i];

     	print RESULT "\t$cell1";
     }
     print RESULT "\n";

     for(my $i = 0; $i < $matrix_length; $i++){
     	my $cell1 = $col_matrix[$i];

     	print RESULT "$cell1";

     	for(my $j = 0; $j < $matrix_length; $j++ ){
     	    my $cell2 = $rows_matrix[$j];
     	    my $join_cell = $cell1.$cell2;

 	    if(exists($sliding{$join_cell})){
 		print RESULT "\t$sliding{$join_cell}";    	
 	    }
    	  
 	    else{
 		print  RESULT "\t0";  
 	    }
 	}

     	print RESULT "\n";
     }
     close (RESULT);
  }







