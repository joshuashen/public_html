# change the case/control status:
# case to missing
# control to case
## ie -->  1 to 2; 2 to 0

# input : .fam

while(<>) {
    chomp;
    @cols = split(/\s+/, $_);
    if ($cols[1] =~ /^(\d+)/) { # SJS samples
	$pheno = 2;
	if ($cols[5] eq '2') {
	    $pheno = 0;
	} 
	print "$cols[0] $cols[1] $cols[2] $cols[3] $cols[4] $pheno\n";
    } elsif ($cols[1] =~ /^NA/) {
	print "$cols[0] $cols[1] $cols[2] $cols[3] $cols[4] $cols[5]\n";

    }
	
}
   
		
