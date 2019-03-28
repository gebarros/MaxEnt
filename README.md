## Maximum Entropy Genomics Tool
**General Information** 

This tool is able to discriminate anomalous regions in the bacterial genome, based on Maximum Entropy method.

Besides, for those genomes available in public database is possible to access automatically the proteins that are present in the predicted regions.

The main purpose is to facilitate and to guide the researcher to regions of the genome that may contain distinctive features about the bacterium, in a fast way.

**Requimements**

I- _OS- Linux:_
- This tool must be executed in a command line, it was tested on Ubuntu 12.04

II- _Perl:_
- standard perl

III- _BioPerl modules:_
- POSIX
- Bio::Seq
- Bio::SeqIO
- Getopt::Long
- Pod::Usage
- Statistics::Descriptive

IV- _R language:_
- standard R

 **Folder Contents**
_The main directory:_
I- MaxEnt_genomics (Main executable)
II-ExploringAnomalousRegions (Optional executable)
III- modules/ (Directory containing five modules required to 

_MaxEnt_genomics execution):_
- module i: Sliding_window;
- module ii: Max_Ent;
- module iii: Editing_coord_file;
- module iv: Display_signature;
- module v: Selecting_anomalous_regions;

 **Inputs and Outputs**

_Inputs_ (For more details see below):

I- Complete genome in fasta format (Mandatory);

II- File in ptt* format that contains the proteins list and their coordinates, specific for the genomes deposited in public database (NCBI - National Center for Biotechnology Information, this file can be downloaded from this link: ftp://ftp.ncbi.nih.gov/genomes/) (Optional);

III- File in rnt* format that contains the RNA list and their coordinates, specific for the genomes deposited in public database (NCBI - National Center for Biotechnology Information, this file can be downloaded from this link: ftp://ftp.ncbi.nih.gov/genomes/) (Optional);

*NCBI PTT File Format - protein table.

*NCBI RNT File Format - RNA table.

_Output_ (For more details see below):

I- Outputs_(id)_(regions number) directory:

i- Signature.pdf file (Shows the signature of the bacterium in study, based on how many regions the user wants);

ii- coordinates.txt file (Contains the regions with their respective coordinates, based on signature);

iii- PredictedAnomalousRegions file (Contains the regions with the maximum entropy value greater or equal the third quartile);

iv- AdditionalResult_(id) directory (Intermediate files generated):

- Substrings.fasta corresponding to each region;

- EntMax_result.txt file;

- list_EM.csv file.

v- ProteinsInAnomalousRegions (Optional);

vi- RegionsPredictedWithRibosomal (Optional).

**Step by step**

**i-** *Copy the genome sequence in fasta format to this folder;*
**ii-** *Run EntMax_genomics:*

    perl MaxEnt_genomics -f -w -id -n -c

_Parameters:_

    -h :Shows this help.
    -f :File name in the FASTA format.
    -w : Window size (base pairs number - Example 10000)
    -id :Identification of the sequence.
    -n : Number of nucleotides that user wants to see the frequency (1 for dinucleotide, 2 for tetranucleotide or 3 for hexanucleotide).
    -c : Starting coordinate to processing.

*Example:*

    perl MaxEnt_genomics -f bacterium.fasta -w 10000 -id bac10 -n 3 -c 1

With this analysis the user will have the outputs cited above, that can be explored.

**iii-** *Run ExploringAnomalousRegions (Optional):*

If the genome has the annotation files available (*ptt and rnt extension*), it is possible`enter code here` to get the proteins present in the predicted regions and to know whether some predicted region contain ribosomal.

**iii.i-** *Copy the file.ptt and file.rnt to the Outputs_(id) directory;*

**iii.ii-** *Inside of the Outputs_(id) directory run:*

    perl ../ExploringAnomalousRegions -f -p -r -id

**Parameters:**

    -h :Shows this help.
    -f :PredictedAnomalousRegion file (Obtained by the previous step).
    -p :File name in ptt format (Obtained by NCBI).
    -r :File name in rnt format (Obtained by NCBI).
    -id :Genome identification.

*Example:*

     perl ../ExploringAnomalousRegions -f PredictedAnomalousRegions -p myfile.ptt -p myfile.rnt -id bac10


 **Contact** 
*Gesiele Almeida Barros de Carvalho*
e-mail: gebarrosbio@gmail.com

**Acknowledgement** 

> FAPESP grant # 2011/50761-2, CNPq, CAPES, NAP eScience - PRP - USP
