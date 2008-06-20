## convert illumina genotype result to PLINK ped format

# input: 1. genotype result. 2 sample summary

# 

use strict;
use Getopt::Long; 
use FileHandle;
use vars qw/$opt_help $opt_gtype $opt_summary $opt_map $opt_out/;

my ($flag, %gender, %pheno, %column, %gtype, $rs, @cols, $id, %map);

$opt_out = "forPLINK";

GetOptions("help|h", "gtype|g=s", "summary|s=s", "map|m=s","out|o=s");

if($opt_help || !($opt_gtype) || !($opt_summary) || !($opt_map)) {
    &usage();
    exit;
}

my $pedOut = $opt_out.".ped";
my $mapOut = $opt_out.".map";


open(IN,$opt_summary) or die("bad file $opt_summary\n");
$flag = 0;
while(<IN>) {
    if (/^Sample\s+ID/) {  # header line
	while(<IN>) {
	    if (/^(\S+)\s+(\S+)\s+(\S+)/) {
		$id = $1;
		if ($2 eq 'Male') {
		    $gender{$id} = 1;
		}elsif ($2 eq 'Female') {
		    $gender{$id} = 2;
		}else {
		    $gender{$id} = 0;
		}
		if ($3 eq 'case') {
		    $pheno{$id} = 2; # affected
		} elsif ($3 eq 'control') {
		    $pheno{$id} = 1;  # unaffected
		} else {
		    $pheno{$id} = 0; # missing
		}
		
	    }
	}
    }
}
close(IN);



$flag  = 0 ; 
open(IN, $opt_gtype) or die("bad file $opt_gtype\n");
while(<IN>) {
    chomp;
    if (/^Name\s+(.*)$/) {
	@cols = split(/\s+/, $1);
	my $count = 0;
	foreach my $id (@cols) {
	    if ($gender{$id}) {
		$column{$id} = $count;
	    }
	    $count ++;
	}
    
	while(<IN>) {
	    @cols= split(/\s+/, $_);
	    $rs = $cols[0];
	    $map{$rs} = '';

	    foreach $id (keys %column) {
		my $gg = $cols[$column{$id}+1];
		if ($gg ne 'AA' || $gg ne 'AB' || $gg ne 'BB')
		    $gg = '00';
		}
		$gtype{$rs}{$id} = $gg;
	    }
	}
    }
}
close(IN);

## output .ped

open(OUT, ">$pedOut") or die ("bad file $pedOut\n");
foreach $id (sort keys %column) { 
    # phenotype set as 1 -- unaffected;
    print OUT "$id\t1\t0\t0\t$gender{$id}\t$pheno{$id}\t";
    foreach $rs (sort keys %gtype) {
	print OUT join(" ", split('', $gtype{$rs}{$id})), "\t";
    }
    print OUT "\n";
}
close(OUT);

print STDERR "Done with outputing .ped file\n";

exit;

# read source .map file
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

