## make mapfile required by PennCNV's visualize_cnv.pl 

use File::Basename;

$file = shift;



open(IN, $file) or die("Bad file $fof\n");

$count = 1;
%hash = {};
while(<IN>) {
    @cols = split(/\s+/, $_);
#    $ori = basename($cols[4]);
    $ori = $cols[4];
    $new = basename($cols[4]);
    next if $hash{$ori}; 

    $hash{$ori} ++ ;
    if ($new=~/^(\S+)\./) {
	$sample = $1;
	print "$ori\t$sample\n";
	$count ++;
    }
}

close(IN);
