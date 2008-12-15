## change matched controls to pseudo cases

$matched = shift;

$controls = {};

open(IN, $matched) or die("bad file $matched\n");
while(<IN>) {
    if(/^(\S+)/) {
	$controls{$1} = 1;
    }
}
close(IN);

while(<>) {
    if (/^(\S+)(\s+\S+\s+\S+\s+\S+\s+\S+\s+)(\S+)/) {
	if ($controls{$1} > 0) { # matched controls
	    print $1,$2,"2\n";
	}else { # pop controls 
	    print $_;
	}
    }
}
