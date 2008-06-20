## modified from extractIndividuals.awk


use Getopt::Long;
use strict;

my ($outdir, $infile);

GetOptions("infile=s" => \$infile, "outdir=s" => \$outdir);

if ($infile eq "") || ($outdir eq "") {
    print "usage:  perl __.pl -infile <input csv file> -outdir <output dir>\n";
    exit(-1);
}

