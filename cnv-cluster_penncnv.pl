### cluster CNVs from PennCNV, compare the case and controls

use strict;
use File::Basename;
use Getopt::Long;

## my $cnvs = ARGV.shift; # a list of files


use vars qw/%cnvs @cols $frag $cnvcol $chr $s $e $hmmstate $cnv $sample @c $laste/; 
use vars qw/$opt_minoverlap $opt_minclusterSize $opt_minCNVsize $opt_minSNPs $opt_help $opt_minblocks/;

$opt_minoverlap = 1000;
$opt_minclusterSize = 2000;
$opt_minSNPs = 3;
$opt_minblocks = 2;

GetOptions(
	   "help|h", "minoverlap|m=i", "minclusterSize|c=i", "minSNPs|s=i", 
	   "minblocks|b=i");

if ($opt_help) {
    &usage();
}



while(<>) {
#    if (/^(\S+)/) {
    @cols = split(/\s+/, $_);
    $frag = $cols[0];
    $cnvcol = $cols[3];
    $sample = basename($cols[4]);

    if ($frag =~ /^(\S+)\:(\d+)\-(\d+)/) {
	$chr = $1;
	$s = $2;
	$e = $3;
    }

    next if ($e - $s + 1 < $opt_minclusterSize);

    if ($cnvcol=~ /^state(\d+)\,cn\=(\d+)/ ) {
	$hmmstate = $1;
	$cnv = $2;
	
	if ($cnv < 2) { # loss
	    $cnv = '-';
	} elsif ($cnv > 2) { # gain
	    $cnv = "+";
	}
    }
    $cnvs{$cnv}{$chr}{$s}{$e}{$sample} = 1;
}


# make clusters

foreach $cnv (sort keys %cnvs) {
    foreach $chr (sort keys %{$cnvs{$cnv}}) {
#	my ($x, $y);
	my @array = sort { $a <=> $b} ( keys %{$cnvs{$cnv}{$chr}}); # sort by start pos

	$laste = -1;
	@c = (); # current cluster
#	print scalar(@array), "\n"; #, join("\t", @array), "\n\n";
	my $cc = 0;
	foreach $s (@array) {
	    my $ee  =join("|", (keys %{$cnvs{$cnv}{$chr}{$s}}));
#	    print "$cc\t$s\t$laste\t$ee\n";
	    $cc++;
	    if ($s > ($laste - $opt_minoverlap))  { # a new cluster                  
#		print "$s\t";
		#	&dump(@c, $cnv, $chr); # dump previous one                       
		&dump();
		@c = ();
	    }
	    foreach $e (keys %{$cnvs{$cnv}{$chr}{$s}}) {
	#	print "end: $e\n";
		if ($e > $laste) {
		    $laste = $e;
		}
		my $aa = "$s-$e";
		push(@c, $aa);
	    }
	}
	&dump;
#	print "\n";
    }
}


# ---- sub
sub dump {
    return if scalar(@c)< 1;
    my (%samples,$s,$e);
    
    my $str = '';
    
    foreach my $block (@c) {
	if ($block=~ /^(\d+)\-(\d+)/) {
	    $s = $1;
	    $e = $2;
	    $str .= "$block";
	    foreach my $sample (keys %{$cnvs{$cnv}{$chr}{$s}{$e}}) {
		$samples{$sample} = 1;
		$str .=",$sample;";
	    }
	}
    }
    my $num = scalar(keys %samples); 

    if ($num >= $opt_minblocks) {
	print "$cnv\t$chr\t$num\t$str\t$laste\n";
    }
}
