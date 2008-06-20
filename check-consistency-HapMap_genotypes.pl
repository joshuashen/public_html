## purpose: remove genotyping errors

# check if the genotypes from HapMap II and HapMap III are consistent. 
# because it seems there are many genotype errors in HapMap III data. for example: rs12260568 is almost 100% G in both SJS/case/control and HapMap II Illumina 1M sets, but >99% A in HapMap III CEU set. 


# input: PLINK transposed files: tped and tfam

use strict;
use Getopt::Long;
use vars qw/$opt_help $opt_t1 $opt_t2 $opt_out $opt_diff/;

my (%sample, %common, $line, %genotype, $id);
my ($base1, $base2, $rs); 

GetOptions("help|h", "t1|t1=s", "t2|t2=s", "out|o=s", "diff|d=s");

if($opt_help || !($opt_t1) || !($opt_t2)) {
    &usage();
    exit;
}

open(IN, $opt_t1.".tfam") or die("File $opt_t1.tfam not found");
$line= 1;
while(<IN>){
    if (/(NA\S+)\s+/) {
	$sample{$1} = $line;
    }
    $line++;
}
close(IN);

open(IN, $opt_t2.".tfam") or die("File $opt_t2.tfam not found");
$line=1;
while(<IN>) {
    if (/(NA\S+)/) {
	if ($sample{$1}) { 
	    $common{$1} = $line;
#	    print  "$1\n";
	}
    }
    $line++;
}
close(IN);


foreach $id (keys %common) {
#    print "$id\t$sample{$id}\t$common{$id}\n";
}

#exit;

open(IN, $opt_t1.".tped") or die("File $opt_t1.tped not found\n");
while(<IN>) {
    chomp;
    my @cols = split(/\s+/, $_);
    $rs = $cols[1];
    next unless ($rs =~ /^rs\d+/);

    my $total = 0;
	
    foreach $id (keys %common) {
	my $index = $sample{$id}*2 + 2;

	$base1 = $cols[$index];
	$base2 = $cols[$index + 1];
	$genotype{$rs}{$id} = join('', sort($base1, $base2)); 
    }
}
close(IN);

print "#rs\tgood\tbad\tmissing\n";
open(IN, $opt_t2.".tped") or die("File $opt_t2.tped not found\n");
while(<IN>) {
    chomp;
    my @cols = split(/\s+/, $_);
    my $rs = $cols[1];

    next unless ($genotype{$rs});
    
    my $good = 0;
    my $bad =0;
    my $miss = 0;

    foreach $id (keys %common) {
	my $index = $common{$id}*2 + 2;
	$base1= $cols[$index];
	$base2= $cols[$index + 1];
	
	my $gtype = join('', sort($base1, $base2)); 
	
	if ($gtype eq '00' ||  $genotype{$rs}{$id} eq '00') {
	    $miss ++;
	}elsif ($gtype eq $genotype{$rs}{$id}) { # same gtype
	    $good ++;
	}else { #may be flip or bad
	    my $cc = &compl($gtype);
	    if ($cc eq $genotype{$rs}{$id}) { # flip
		$good++;
	    } else {
		$bad++;
		print STDERR "$rs\t$index \t $id\t $cc\t $genotype{$rs}{$id}\t $gtype\n";
	    }
	}
    }
    print "$rs\t$good\t$bad\t$miss\n";


}
close(IN);



### sub
sub compl {
    my $base = shift;
    $base =~ tr/ACGT/TGCA/;
    
    return reverse($base);
}


sub usage {
    print "Usage: perl __.pl -t1 first_dataset -t2 second_dataset -d diff.out\n";
    print "  note: the first and second data sets should be in PLINK transposed format; tped and tfam files are required\n";
    return;
}


