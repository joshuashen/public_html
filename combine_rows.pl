## 

my %h = {};

while(<>) {
    if (/^(\S+)\s+(\S+)/) {
	$h{$1} .= $2."\t";
    }
}

foreach my $id (sort keys %h) {
    print "$id\t$h{$id}\n";
}
