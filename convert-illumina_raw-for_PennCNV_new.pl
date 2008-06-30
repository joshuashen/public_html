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

my $idMap = "/nfs/apollo/2/c2b2/users/saec/DILI/meta-data/diliID_illuminaID.map";
my (%map, %chr, %pos);
my $snpinfo = "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/illumina1M.sorted.map";

open(IN, $idMap) or die ("Bad map file $idMap\n");
while(<IN>) {
    if (/^(\S+)\s+(\S+)/) {
	$map{$2} = $1;
    }
}
close(IN);

open(IN, $snpinfo) or die ("bad file $snpinfo\n");
while(<IN>) {
    if (/^(\S+)\s+(\S+)\s+\S+\s+(\d+)/) {
	$chr{$2} = $1;
	$pos{$2} = $3;
    }
}
close(IN);

while(<>) {
    next if (/^SNP/);
    @cols = split(',', $_);
    next if scalar(@cols) <= 9; 
    $sampleID = $cols[1];
    next unless $map{$sampleID};

    if ($sampleID ne $lastsample) { # a new sample
	my $diliname = $map{$sampleID}; 
	my $out = $diliname.".PennCNV.input";
	close(OUT);
	open(OUT, ">$out") or die("bad file $out\n");
	print OUT "Name\tChr\tPosition\t$diliname.Gtype\t$diliname.Log R Ratio\t$diliname.B Allele Freq\n";
	$lastsample = $sampleID;
    }
    
    my $gtype = '';
    if (abs($cols[5] - 1) < 0.24) {
	$gtype = "BB";
    } elsif (abs($cols[5]) < 0.24) {
	$gtype = "AA";
    } elsif (abs($cols[5] - 0.5) < 0.24) {
	$gtype = "AB";
    } else {
	$gtype = "NN";
    }
    
    print OUT "$cols[0]\t$chr{$cols[0]}\t$pos{$cols[0]}\t$gtype\t$cols[6]\t$cols[5]\n";

}
close(OUT);

