## detemine phenotype (case / control status) by sample name:

# DILI samples start with 20460 are controls from GSK PopRes db

while(<>) {
    chomp;
    if (/^Sample/) {
	print $_, "\tPhenotype\n";
	while(<>) {
	    chomp;
	    if (/^(\S+)\s+(\S+)/) {
		$id = $1;
		$gender = $2;
		if ($id=~ /(\S+)\_20460\-(\S+)/) { # controls
		    print $_, "\tcontrol\n";
		} else {
		    print $_, "\tcase\n";
		}
	    }
	}
    }
}


