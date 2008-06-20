## this is for separate cases from controls in the combined genotype result

use strict;
use Getopt::Long;

use vars qw/$opt_help $opt_input $opt_cols/;

my (%cols, @s, $c, $i, @a);

GetOptions("help|h", "input|i=s", "cols|c=s");

if($opt_help || !($opt_input) || !($opt_cols)) {
    &usage;
    exit;
}

open(IN,$opt_cols) or die("Bad column file $opt_cols\n");
while(<IN>) {
    if (/^(\S+)/) {
	$cols{$1} ++ ;
    }
}
close(IN);

open(IN, $opt_input) or die ("Bad input file $opt_input\n");
while(<IN>) {
    chomp;
    if (/^Name\tChr/) { # header line
	@s = split(/\t/, $_); ## assuming a tab-delimited file
	
	for ($i=0;$i<3;$i++) {
	    $c = $s[$i];
	    print "$c\t";
	    push(@a, $i);
	}

	for ($i=3;$i < (scalar @s); $i ++ ) {
	    $c = $s[$i];
	    if ($c=~/^(\S+)\.(\S+)/) { 
		if ($cols{$1}) { # of interested
		    push(@a, $i);
		    print "$c\t";
		}
	    }
	}
	print "\n";

    } else {
	@s = split(/\t/, $_);
	foreach $i (@a) {
	    print "$s[$i]\t";
	}
	print "\n";
    }
}
close(IN);

## sub

sub usage {
    print "Usage: perl __.pl -i input -c columns > output\n";
}
