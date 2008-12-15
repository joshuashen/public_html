# input: PennCNV output

use strict;

my $minSNP = 3; # should be specified by command line later

my (@cols, $numsnp, $length, $chr);

while(<>) { 
    @cols = split(/\s+/, $_);

    if ($cols[0] =~ /^(chr\S+)\:\d+/) {
	$chr = $1;
    }
    
    if ($cols[1]=~/numsnp\=(\d+)/) {
	$numsnp = $1;
    }
    
#    print $cols[2]."\n";
    if ($cols[2]=~ /length=(\S+)/) {
	$length = $1;
    }

    $length =~ s/,//g;
    
    print  "$length\t$numsnp\t$chr\n";
    

}
    
