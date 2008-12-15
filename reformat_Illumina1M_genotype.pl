## to be used by reformat.qsub

# input: a list of original Illumina SJS genotype data, output directory

# output: 


use Getopt::Long;
use strict;

my ($infile, $infilelist, $outdir, $outfile);

my $result = GetOptions("infile=s" => \$infile, "infilelist=s" => \$infilelist, "outdir=s" => \$outdir, "outfile=s" => \$outfile);

if (($infile eq "" && $infilelist eq "") || $outdir eq "") {
    print "usage 1: perl __.pl -infile <SNP data in csv format> -outdir <output dir> -outfile <output file>\n";
    print "usage 2: perl __.pl -infilelist <a file containing the names of a list of csv files with SNP data> -outdir <output dir> -outfile <output file>\n";
    exit(-1);
}


open(OUT)



    
