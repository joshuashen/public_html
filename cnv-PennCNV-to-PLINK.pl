## prepare for CNV analysis via PLINK

# basic PLINK command:  plink --cnv-list mydata.cnv

use strict;
use Getopt::Long;
use vars qw/$opt_help $opt_phenotype $opt_exclude $opt_fof $opt_output/;

my (%penncnv, $f, %samples);


GetOptions("help|h", "phenotype|p=s", "exclude|e=s", "fof|f=s", "output|o=s");

if($opt_help || !($opt_fof) || !($opt_phenotype)) {
    &usage();
    exit;
}

if (!($opt_output)) {
    $opt_output = "penncnv"; # default output prefix
}

open(IN, $opt_fof) or die("Bad fof file $opt_fof\n");
while(<IN>) {
    if(/^(\S+)/) {
	$penncnv{$1} = 1;
    }
}
close(IN);

my $cnvout = $opt_output.".cnv";
open(OUT, ">$cnvout") or die ("Bad cnv out: $cnvout\n");
foreach $f (sort keys %penncnv) {
    my $str = &addperson($f);
    print OUT $str;
}
close(OUT);


my $phenoOut = $opt_output.".fam";
open(OUT, ">$phenoOut") or die("Bad fam output: $phenoOut\n");

open(IN, "$opt_phenotype") or die("Bad phenotype file $opt_phenotype\n");
## samples not in %penncnv hash will be ignored
while(<IN>) {
    if (/^(\S+)\s+(\S+)/) {
	my $sample = $1;
	my $phe = $2;
	my $case = 2; # default is 2, which means case in PLINK
# 	print STDERR "$sample\n";
 	if ($samples{$sample}) {
	    if ($phe eq 'control') {
		$case = 1;  # control
	    }
	    print OUT "$sample\t$sample\t0\t0\t1\t$case\n";
	}
    }
}
close(IN);
close(OUT);

# ------ subroutines ------

sub usage {
    print "Usage: perl __.pl -p phenotype.txt -f list_of_PennCNV_result_files [ -e exclude.samples.list]\n";
    return;
}

sub addperson {
    my ($file, @cols, $sampleName, $chr,$s,$e,$sites,$type, $out);
    $file =shift;
    $out = '';
    if ($file=~/^(\S+)\./) {
	$sampleName = $1;
	$samples{$sampleName} = 1;
    }
    open(IN, $file) or die("bad penncnv file $file\n");
    while(<IN>) {
	@cols = split(/\s+/, $_);
	if ($cols[0]=~ /^chr(\S+)\:(\d+)\-(\d+)/) {
	    $chr=$1;
	    $s = $2;
	    $e = $3;
	}
	
	if ($cols[1]=~ /^numsnp\=(\d+)/) {
	    $sites = $1;
	}

	if ($cols[3]=~ /^state\d+\,cn=(\d+)/) {
	    $type = $1;
	}
	$out  .= "$sampleName\t$sampleName\t$chr\t$s\t$e\t$type\t0\t$sites\n";
    }
    close(IN);
    return $out;
}


## Comments:

# format: 
#     FID     Family ID
#     IID     Individual ID
#     CHR     Chromosome
#     BP1     Start position (base-pair)
#     BP2     End position (base-pair)
#     TYPE    Type of variant, e.g. 0,1 or 3,4 copies
#     SCORE   Confidence score associated with variant 
#     SITES   Number of probes in the variant
