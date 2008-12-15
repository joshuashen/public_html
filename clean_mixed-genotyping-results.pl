
# When using population controls from diverse source, genotyping errors can cause spurious associations.
# 1. strand problem, C/G and A/T SNPs should be excluded.
# 2. pay attention to p-values in case vs  matched controls  and case vs pop controls

use strict;
use Getopt::Long;
use vars qw /$opt_help $opt_original $opt_combined $opt_cvc/;


GetOptions("help|h","original|m=s","combined|p=s", "cvc|c=s");

if($opt_help || !$opt_original || !$opt_combined || !$opt_cvc) {
    &help();
}

my (%matchedP, %cvcP, $line);

open(IN, $opt_original) or die("Cannot open the original association result with matched controls\n");
while(<IN>) {
    my @cols = split(/\s+/, &strip($_));
    $matchedP{$cols[1]} = $cols[8]; 
}
close(IN);

open(IN, $opt_cvc) or die("Cannot open the control vs control result\n");
while(<IN>) {
    my @cols = split(/\s+/, &strip($_));
    $cvcP{$cols[1]} = $cols[8]; 
}
close(IN);

open(IN, $opt_combined) or die("Cannot open the association result of the combined set\n");
while(<IN>) {
    $line = &strip($_);
    print $line, "\tMatchedP\tCVCP\tFlag\n";  # header
    while(<IN>) {
	$line = &strip($_);
	my @cols = split(/\s+/, $line);
	my $mp = 1;
	my $flag = "y";
	my $cp = 1; 
	if ($matchedP{$cols[1]}) {
	    $mp = $matchedP{$cols[1]};
	}
	
	if ($cvcP{$cols[1]}) {
	    $cp = $cvcP{$cols[1]};
	}
	
	if (($cols[3] eq 'A' && $cols[6] eq 'T') || ($cols[3] eq 'T' && $cols[6] eq 'A') || ($cols[3] eq 'C' && $cols[6] eq 'G') || ($cols[3] eq 'G' && $cols[6] eq 'C') ) {
	    $flag = "n";
	}
	
	print $line, "\t", $mp, "\t", $cp, "\t", $flag, "\n";
    }
}
close(IN);

# ----- 
sub help {
    print "Usage: perl __.pl -o original_w_matched_controls -p combined_w_pop_controls -c control_vs_controls\n";
    exit;
}

sub strip {
    my $s = shift;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    return $s;
}
