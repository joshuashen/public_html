## convert illumina genotype result to PLINK ped format

# input: 1. genotype result. 2 sample summary

# 

use strict;
use Getopt::Long; 
use FileHandle;
use vars qw/$opt_help $opt_gtype $opt_summary $opt_map $opt_out $opt_nomap/;

my ($flag, %gender, %column, %gtype, $rs, @cols, $id, %map);

$opt_out = "forPLINK";

GetOptions("help|h", "gtype|g=s", "summary|s=s", "map|m=s","out|o=s", "nomap|n");

if($opt_help || !($opt_gtype) || !($opt_summary) || !($opt_map)) {
    &usage();
    exit;
}

my $pedOut = $opt_out.".ped";
my $mapOut = $opt_out.".map";


open(IN,$opt_summary) or die("bad file $opt_summary\n");
$flag = 0;
while(<IN>) {
    if (/^Sample\s+ID/) {
	$flag =  1;
    } elsif ($flag == 1) {
	my @cols = split(/\s+/, $_);
	$id = $cols[0];
	if ($cols[11] eq 'M') {
	    $gender{$id} = 1;
	}elsif ($cols[11] eq 'F') {
	    $gender{$id} = 2;
	}else {
	    $gender{$id} = 0;
	}

    }
}
close(IN);



$flag  = 0 ; 
open(IN, $opt_gtype) or die("bad file $opt_gtype\n");
while(<IN>) {
    if (/\[Data\]/) {
	while(<IN>) {
	    @cols= split(/\s+/, $_);
	    if (/CaseSample/) { # sample ID line
		my $count = 0;
		foreach my $s (@cols) {
		    if ($s=~ /^Control\_(\S+)/) {
			$id = $1;
			if ($gender{$id}) {
			    $column{$id} = $count;
			}
			$count ++;
		    }

		}
		while(<IN>) {
		    @cols= split(/\s+/, $_);
		    $rs = $cols[0];
		    $map{$rs} = '';

		    foreach $id (keys %column) {
			    
			my $gg = $cols[$column{$id} + 2];
			if ($gg eq '--') {
			    $gg = '00';
			}
			$gtype{$rs}{$id} = $gg;
		    }

		}
	    } 
	}
    }
}
close(IN);

## output .ped

open(OUT, ">$pedOut") or die ("bad file $pedOut\n");
foreach $id (sort keys %column) { 
    # phenotype set as 1 -- unaffected;
    print OUT "$id\t1\t0\t0\t$gender{$id}\t1\t";
    foreach $rs (sort keys %gtype) {
	print OUT join(" ", split('', $gtype{$rs}{$id})), "\t";
    }
    print OUT "\n";
}
close(OUT);

print STDERR "Done with outputing .ped file\n";
# release memory
#foreach $rs (keys %gtype) {
#    $gtype{$rs} = 1;
#}

# read source .map file

if($opt_nomap) {
    exit;

}

open(IN, $opt_map) or die("bad file $opt_map\n");
while(<IN>) {
     if (/^(\S+)\s+(\S+)\s+/) {
	if ($gtype{$2}) {
	    $gtype{$2} = 1;
	    $map{$2} = $_;
	}
    }
}
close(IN);

# output SNP .map

open(OUT, ">$mapOut") or die("bad file $mapOut\n");
foreach $rs (sort keys %gtype) {
    if ($map{$rs}) {
	print OUT "$map{$rs}";
    } else {
	print OUT "0\t$rs\t0\t-1\n";
    }
}
close(OUT);

### sub
sub usage{
    print "Usage: perl __.pl -g genotype.txt -s summary -m chip_probes.map -o prefix_of_output \n";
    
}

