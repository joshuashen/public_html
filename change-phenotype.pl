## .ped files from HapMap III are 0/1 coded for phenotype data,
## this script change 0/1 code to PLINK's default code:

# 0/1 code:
#     -9 missing
#      0 unaffected
#      1 affected

# default code:
#    -9 missing 
#     0 missing
#     1 unaffected
#     2 affected

my ($phe, $s);

## input: .ped file
while(<>) {
    chomp();
    # the phenotype is in 6th column:
    if(/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+)\s+(\S+)\s+(.*)$/) {
	if ($2 eq '0') { # unaffected
	    $phe = 1;
	} elsif ($2 eq '1') { # affected
	    $phe = 2;
	} else {
	    $phe = $2;
	}
	print "$1 $phe $3\n";
    }
}
