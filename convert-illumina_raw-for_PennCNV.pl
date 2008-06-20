## convert the file to PennCNV input format.

# the original file: /nfs/apollo/2/c2b2/users/saec/HapMap/Illumina1M/Illumina_Raw_Data/Illumina_Human1Mv1.0/Illumina_1M_Samples_1-63_Confidential.txt

# and /nfs/apollo/2/c2b2/users/saec/HapMap/Illumina1M/Illumina_Raw_Data/Illumina_Human1Mv1.0/Illumina_1M_Samples_64-125_Confidential.txt

# target format (one sample per file):

## Name    Chr     Position        sampleID.GType  sampleID.Log R Ratio  sampleID.sampleID.B Allele Freq
# rs2402200       14      92353660        AB      0.1436315       0.523756

# command:  cat ~/HapMap/Illumina1M/Illumina_Raw_Data/Illumina_Human1Mv1.0/Illumina_1M_Samples*Confidential.txt | perl ~/SJS/usr/ys/perl/convert-illumina_raw-for_PennCNV.pl
# work Dir: 

use strict;

my @cols;
my $sampleID = "";
my $lastsample = "";

while(<>) {
    next if (/^Sample/);
    @cols = split(/\s+/, $_);
    next if scalar(@cols) <= 12;  ## should be 13 columns
    $sampleID = $cols[0];

    if ($sampleID ne $lastsample) { # a new sample
	my $out = $sampleID.".PennCNV.input";
	close(OUT);
	open(OUT, ">$out") or die("bad file $out\n");
	print OUT "Name\tChr\tPosition\t$sampleID.Gtype\t$sampleID.Log R Ratio\t$sampleID.B Allele Freq\n";
	$lastsample = $sampleID;
    }
    
    my $gtype = '';
    if (abs($cols[11] - 1) < 0.24) {
	$gtype = "BB";
    } elsif (abs($cols[11]) < 0.24) {
	$gtype = "AA";
    } elsif (abs($cols[11] - 0.5) < 0.24) {
	$gtype = "AB";
    } else {
	$gtype = "NN";
    }
    
    print OUT "$cols[1]\t$cols[2]\t$cols[3]\t$gtype\t$cols[12]\t$cols[11]\n";

}
close(OUT);

