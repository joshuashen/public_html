## purpose: convert controls to cases

while(<>) {
    chomp;
    @cols = split(/\s+/, $_) ;
    if ($cols[1] =~ /^NA/) { # not SJS samples
	print "$_\n";
    }else {
	print "$cols[0] $cols[1] $cols[2] $cols[3] $cols[4] 2\n";
    }
}

