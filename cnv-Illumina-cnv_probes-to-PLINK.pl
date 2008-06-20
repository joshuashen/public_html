## format the result from illumina 1M CNV probes for PLINK analysis

# this deals with making PED file
# the MAP file can be extracted from the overall map file: /PATH-to/data/illumina1M.map

# The PED file is a white-space (space or tab) delimited file: the first six columns are mandatory:
#     Family ID
#     Individual ID
#     Paternal ID
#     Maternal ID
#     Sex (1=male; 2=female; other=unknown)
#     Phenotype

# The phenotype can be either a quantitative trait or an affection status column. Affection status, by default, should be coded:
#    -9 missing 
#     0 missing
#     1 unaffected   - control
#     2 affected     - case

# Genotypes (column 7 onwards) should also be white-space delimited; All markers should be biallelic.


use strict;
use Getopt::Long;
# global variables
use vars qw/$opt_help $opt_phenotype $opt_output/; 

my ($sample, $caco, %pheno, @cols);

GetOptions("help|h", "phenotype|p=s", "output|o=s");
if ($opt_help || !($opt_phenotype)) {
    &usage;
    exit;
}

open(IN, "$opt_phenotype") or die("Bad phenotype file $opt_phenotype\n");
while(<IN>) {
    if(/^\#/) {
	next;
    }elsif(/^(\S+)\s+(\S+)/) {
	$sample = $1;
	$caco = $2;
	if ($caco eq 'case') {
	    $pheno{$sample} = 2; # cases
	} else { 
	    $pheno{$sample} = 1; # controls
	}
    }
}
close(IN);

# it's like transpose a matrix, input data is a SNP per line,
# output is a sample per line, SNPs are in columns
# need intermediate files to save memory

while(<>) { # read in genotype result from file or STDIN
    if(/^Name\tChr/) { # header line
	next;
    } 
    
    @cols = split(/\t/, $_);
}
    
    


############# Subroutines

sub usage {
    print "Usage: perl __.pl  < genotype_result -p phenotype_info -o output\n\n";
    print "        genotype_result    a file exported from BeadStudio, should be format like this: \n";
    print "SNP_NAME    CHR    Position    Sample.GType  Sample.Theta  Sample.R  Sample.... \n";
    return;
}
