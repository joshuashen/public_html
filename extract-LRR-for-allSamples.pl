## purpose: to do correlation coefficient calculation between sample pairs

# example: [saec@gaia data]$ perl ../perl/extract-LRR-for-allSamples.pl illumina1M.BeadStudio_2_PennCNV.txt > illumina1M.BeadStudio_2_PennCNV.txt.LRR


@header = ();

while(<>) {
    @cols = split(/\t/, $_);
    if ($cols[0]=~/^Name/) { # header line
	print "Name\t";
	$count = 0;
	push(@header, $count); # push the first col
	foreach $c (@cols) {
	    if ($c=~ /(\S+)\.Log\sR\sRatio/) { # good column
		print "$1.LRR\t";
		push(@header, $count); # push the LRR col
	    }
	    $count ++ ;
	}

	print "\n";
    } else { # genotype lines
	foreach $i (@header) {
	    print "$cols[$i]\t";
	}
	print "\n";
    }
}

