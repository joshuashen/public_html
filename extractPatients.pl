#!/usr/bin/perl
## Extract individual patients from the original GSK file
#  we are going to use the file mapping_info.txt to map Illumina IDs with patient IDs
#  input will be 


#perl extractPatients.pl -infile ~/SJS/uploads/SJS-Oct-11-2007/SJS_Delivery_from_GSK/PGX40001_Illumina1M/Extracted\ Genotypes/PGx40001_12278-DNA.csv -outdir ../data -outfile test.out

use Getopt::Long;
use Data::Dumper;
use strict;

my $VERSION = '1_01';

# Check if programm called correctly

my ($fp, $outdir, $fpout, $mapfp);
my $result = GetOptions ("infile=s" => \$fp, "map=s" => \$mapfp, 
						 "outfile=s"=> \$fpout,
						 "outdir=s"=> \$outdir);
if($fp eq "" || $fpout eq "" || $outdir eq "" || $mapfp eq "" ){
	print "**** usage: perl extractPatients.pl -infile <csv file with SNP data> -outdir <output directory>  -map <map file>  -outfile <output file>\n";
	exit(-1);
}

open(OUTPUT2, '>', $fpout) || die("**** Could not open file $fpout!");
print2("#perl extractPatients.pl -infile $fp -outdir $outdir -outfile $fpout\n");
print2("#Version: $VERSION\n");


#read in information about mapping between Illumina individuals and GSK individuals
# file has been created from "PGX40001_GSK_SJS_B137_29Aug2007_DNAReport.xls"

# my $mapfp = '/nfs/apollo/2/c2b2/users/saec/SJS/usr/bernd/data/mapping_info.txt';
open(DAT, $mapfp) || die("**** Could not open file  $mapfp!");
my @map_data=<DAT>;
my %map;
foreach my $m (@map_data) {
	if ($m =~ !/^#/) {
		$m =~ s/[\r\n]//g; #remove end of line characters
		$m =~ /(.*)\t(.*)/;
		$map{lc $1} = $2
	}
}
close(DAT);
if (!defined %map) {
	print2("**** %map not defined");
	die("**** %map not defined");
}
#print Dumper(\%map);

#$ head -30 PGx40001_12278-DNA.csv
#[Header]
#BSGT Version,3.1.10
#Processing Date,8/28/2007 11:53 AM
#Content,,Human1Mv1_C.bpm
#Num SNPs,1069083
#Total SNPs,1072820
#Num Samples,94
#Total Samples,292
#[Data]
#SNP Name,Sample ID,Allele1 - Forward,Allele2 - Forward,Allele1 - AB,Allele2 - AB,X,Y,X Raw,Y Raw,GC Score
#rs758676,WG0012278-DNA_A02_2949_A02,T,C,A,B,0.420,0.611,3306,4684,0.8100
#rs3916934,WG0012278-DNA_A02_2949_A02,T,C,A,B,0.341,0.511,2686,3914,0.9114
#rs2711935,WG0012278-DNA_A02_2949_A02,T,T,A,A,1.033,0.030,8298,255,0.9032
#rs17126880,WG0012278-DNA_A02_2949_A02,C,C,B,B,0.031,1.178,262,9201,0.9278
#rs12831433,WG0012278-DNA_A02_2949_A02,T,C,A,B,0.947,1.015,7620,7947,0.8485
#rs12797197,WG0012278-DNA_A02_2949_A02,T,C,A,B,0.132,0.290,1062,2265,0.8524


open(DAT, $fp) || die("**** Could not open file $fp!");

my $header=0;
my $l = 0;
my $oldId = "empty";

while (<DAT>) {
	#ignore lines until we hit "[Data]"
	#then read one more line
	if ($header<2) {
		if (/^\[Data\]/ || $header >0) {
			$header ++;
		}
		next;
	}
	$ l ++;
	if (!($l % 100000)) {
		print2 ("processing line $l\n");
	}
	my @line = split(/,/);

	if (!defined $map{lc $line[1]}) {
		next;
		print2( "* unknown ID: " . $map{lc $line[1]} . ":::" . $line[1] . "\n");
	}
	if ($oldId ne $line[1]) {
		if (<OUTFILE>) {
			close (OUTFILE);
		}
		open(OUTFILE, ">", $outdir . "/" . $map{lc $line[1]} . ".txt"); 
		print(OUTFILE "#perl extractPatients.pl -infile $fp -outdir $outdir -outfile $fpout\n");
		print(OUTFILE "#Version: $VERSION\n");

	}
	$oldId = $line[1];

	print (OUTFILE $line[0] . "\t" .  $line[2] . "\t" . $line[3] . "\n");


	#print "$_";
}
close(OUTFILE);
close(OUTPUT2);








#===============================

sub print2 {
	
	my ($str) = @_;
	print $str ;
	print(OUTPUT2 $str);
}


