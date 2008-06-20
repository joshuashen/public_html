## split the file 

use strict;
use Getopt::Long;
use FileHandle;
use vars qw/$opt_help $opt_gtype $opt_num $opt_out/;

my ($flag, %pheno, @column, @name, @gtype, $rs, @cols, $id, @gtypeFH, $i, $total, $batches);

$opt_out = "div";
$opt_num = 40;

GetOptions("help|h", "gtype|g=s", "num|n=i", "out|o=s");

if($opt_help || !($opt_gtype)) {
    &usage();
    exit;
}

my $header= '';

open(IN, $opt_gtype) or die ("Bad genotype file $opt_gtype\n");
while(<IN>) {
    chomp;
    if (/^Index/) {
	@cols = split(',', $_);
	my $count = 0; 
	foreach my $s (@cols) {
	    if ($s =~ /^(\S+)\.GType/) {
		push(@column, $count);
		push(@name, $1);
	    }
	    $count ++ ;
	}

	$total = scalar (@column);
	$batches = int($total/$opt_num) + 1;

	print STDERR "Total samples: $total\n";
	for ($i=0; $i<$batches; $i++) {
	    my $po = $opt_out . '_' . $i . ".gtype";
	    $gtypeFH[$i] = new FileHandle ">$po";
	    
	    my $fh = $gtypeFH[$i];
	    
	    my $s = $i*$opt_num;
	    my $e = ($i+1)*$opt_num - 1;
	    my @block = @name[$s..$e];
	    
	    print $fh "Name\t", join("\t", @block), "\n";
	}

	while(<IN>) { # gtypes
	    @cols = split(',', $_);
	    $rs = $cols[1];
	    @gtype = ();
	    
	    foreach my $ii (@column) {
		push(@gtype, $cols[$ii]);
	    }
	    

	    for (my $j=0;$j<$batches - 1;$j++) {
		my $fh = $gtypeFH[$j];
		
		print $fh "$rs\t";
		
		my $ss = $j*$opt_num;
		my $ee = ($j+1)*$opt_num - 1;
		
		my @block = @gtype[$ss..$ee];
		print $fh join("\t", @block), "\n";
	    }
	    
	    my $j = $batches - 1;
	    my $fh = $gtypeFH[$j];
	    my $ss = $j*$opt_num;
	    my $ee = $total - 1 ;
	    my @block = @gtype[$ss..$ee];
	    print $fh "$rs\t", join("\t", @block), "\n";

	}

	foreach my $fh (@gtypeFH) {
	    close($fh);
	}
    }

}


### sub 
sub usage {
    print STDERR "Usage: perl __.pl -g genotype [-n num_per_batch] -o prefix_of_out\n";
    return;
}
