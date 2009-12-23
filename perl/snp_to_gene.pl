# idea: given a list of gene


use strict;
use Getopt::Long;

## defines the variables for taking commandline options
use vars qw/$opt_help $opt_gene $opt_snp $opt_minrsq $opt_maxDist/ ;

my (%genes, $chr, $geneName);

$opt_maxDist = 100; # max physical distance

# take the command line options and assign them to the appropriate varibles
GetOptions("help|h", "gene|g=s", "snp|s=s" ,"minrsq|m=f", "maxDist|d=i");

if ($opt_help || !$opt_gene || !$opt_snp) {
    &help();
    exit;
}

# read the gene list file
&getGenes();

# foreach $chr (sort keys %genes) {
#    foreach $geneName (sort keys %{$genes{$chr}}) {
#	print "$chr\t$geneName\n";
#    }
#}

# assign genes to each SNP
&assignGene();

## sub routines
sub assignGene {
    my ($rs, $pos, $chr, $genelist);
    open IN, "$opt_snp" || die("Bad SNP file\n");
    while(<IN>) {

# pattern match for each line
	if(/^(rs\d+)\,(\S+)\,(\d+)/) {
	    $rs = $1;
	    $chr = $2;
	    $pos = $3;
	    my @genelist = &search($chr, $pos);
	    
	    if (@genelist == 0) {
		print STDERR "$rs\t$chr\t$pos\tNot close to genes\n";
	    } else {
		foreach my $geneName (@genelist) {
		    print "$rs\t$chr\t$pos\t$geneName\n";
		    
		}
	    }
	}

    }
    close(IN);
    return;
}

sub search {
## $_ is the default variable to store the argument provided to the sub-routine.

# my $chr = $_[0]; my $pos = $_[1];

    my $chr = shift(@_);
    my $pos = shift(@_);
    my @genelist;
    
# exaustive search of genes
    foreach my $geneName (sort keys %{$genes{$chr}}) { 
	my @posarray = @{$genes{$chr}{$geneName}};

	my $start = $posarray[0];
	my $end = $posarray[1];
	if (($pos > $start - $opt_maxDist) && ($pos < $end + $opt_maxDist)) {
	    push(@genelist, $geneName);
	#    print STDERR "$posarray->[0]\n";
	}
    }
    return @genelist;
}


sub getGenes {
    my ($chr, $start, $end, $gene);
    open GIN, "$opt_gene" || die("Bad gene file\n");
    while(<GIN>) {
	if (/^(\S+)\s+(\d+)\s+(\d+)\s+(\S+)/) {
	    $chr = $1;
	    $start = $2;
	    $end = $3; 
	    $geneName = "$4\t$start\t$end";
	    @{$genes{$chr}{$geneName}} = ($start, $end);
	}
	
    }
    close(GIN);
    return;
}

sub help {
    print "Usage: perl __.pl -s SNP_file  -g SNP_to_Gene_mapping -d max_physical-distance  > output\n";
    return;
}
