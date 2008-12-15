## split the original file into smaller batches. 


use strict;
use Getopt::Long; 
use FileHandle;
use vars qw/$opt_help $opt_gtype $opt_num $opt_out/;

my ($flag, %pheno, %column, %gtype, $rs, @cols, $id, @gtypeFH, $i);

$opt_out = "div";
$opt_num = 50;

GetOptions("help|h", "gtype|g=s", "num|n=i", "out|o=s");

if($opt_help || !($opt_gtype)) {
    &usage();
    exit;
}


my $header= '';


open(IN, $opt_gtype) or die("Bad file $opt_gtype\n");
$flag = 0 ;
while(<IN>) {
    if (/\[Data\]/) {
	$header .= $_;
	while(<IN>) {
	    chomp;
            if (/(CaseSample\_0)\s+(.*)$/) { # sample ID line   
#		$header .= $_;
		$header .= "\t";
		
		$header .= "$1\t";
		@cols = split(/\s+/, $2);

		my $total = scalar (@cols);
		my $batches = int($total/$opt_num) + 1;
		
		print STDERR "Total samples: $total\n";
		
		for ($i=0; $i<$batches; $i++) {
		    my $po = $opt_out . '_' . $i .".gtype";
		    $gtypeFH[$i] = new FileHandle ">$po";

		    my $fh = $gtypeFH[$i];
		    
		    my $s = $i*$opt_num;
		    my $e = ($i+1)*$opt_num -1; 
		    
		    # print STDERR "$s\t$e\n";
		    my @block = @cols[$s..$e];
		    
		    print $fh $header,"\t", join("\t", @block), "\n";
		    
		}

		
		while(<IN>) { # gtypes
		    chomp;
#		    print STDERR $_,"\n";
		    @cols = split(/\s+/, $_);
		    $rs = $cols[0];
##		    print STDERR "\n$rs\n\n";
		    
		    
		    for (my $j=0; $j<$batches; $j++){
			my $fh = $gtypeFH[$j];
#			print STDERR "$j\t$rs\n";
			print $fh "$rs\t--\t";
			my $ss = $j*$opt_num + 2;
			my $ee = ($j+1)*$opt_num + 1;

			my @block = @cols[$ss..$ee];
	#		print STDERR  "$j\t$ss\t$ee\t\n";
			print $fh join("\t", @block), "\n";
		    }
		}

	    }
	}  
    } else {
	$header .= $_;
	
    }

}


## sub
sub usage{
    print STDERR "Usage: perl __.pl -g gtype.txt [-o prefix_of_output]\n";
    return;
}
