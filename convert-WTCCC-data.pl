use strict;

my $inputFile = shift;
my $prefix = shift;

my $snpMap = "/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/Illumina1M/illumina1M.sorted.map";
use strict;

my ($rs, %map, @cols, $i, $numCols, %genotype, $rs, $gtString);
my $firstGTCol = 1;
my %nameHash = {};
my $batchSize = 200;

open(IN, $snpMap) or die("Cannot open file $snpMap\n");

while(<IN>) {
	chomp();
	@cols = split(/\s+/, $_);
	$rs = $cols[1];
	$map{$rs} = $_ ;
}
close(IN);


 
my $pedOut = $prefix.".ped";
my $mapOut = $prefix.".map";
open(POUT, ">$pedOut");
open(MOUT, ">$mapOut");

my $flag = 0;  # whether all samples were dealt with
my $bookmark = 0;

while ($flag == 0) {
	open(IN, $inputFile);
# Genotype data is from stdin
	while(<IN>) {
		@cols = split(/\s+/, $_);
		$numCols = scalar @cols; 
	# print  "$cols[1]\t$numCols\n";
	
		if ($cols[1] =~ /^\d+/) { # first line
			print $cols[1], "\t", $firstGTCol, "\n";
		
			for($i=$firstGTCol+$bookmark; ($i < $firstGTCol + $bookmark + $batchSize && $i < $numCols ); $i++) {
				$nameHash{$i} = $cols[$i];
			}
			print "\n";
		} else  { # gt lines
			$rs = $cols[0];	
			
			for($i=$firstGTCol+$bookmark; ($i < $firstGTCol + $bookmark + $batchSize && $i < $numCols ); $i++) {
				$gtString = $cols[$i];
				$gtString =~ tr/[N,-,_]/[0,0,0]/;
				if ($gtString=~ /^(\S+)\;/) {
					my @gt = split('', $1);
					$genotype{$nameHash{$i}}{$rs} = "$gt[0] $gt[1]";
				}
			}		
		}
	}
	close(IN);
	my $lastSample = &output();
	
	$bookmark += $batchSize; 
	if ($bookmark + $firstGTCol >= $numCols ) {
		$flag = 1;
		print STDERR $lastSample, "\n";
		&outputMap($lastSample);
	}
	%genotype = ();
}

close(MOUT);
close(POUT);


## subroutines

sub output {
	my $sample;
	foreach $sample (sort (keys %genotype)) {
		print POUT "$sample 1 0 0 2 1";
		foreach $rs (sort keys %{$genotype{$sample}}) {
			if ($map{$rs}) {
				print POUT " $genotype{$sample}{$rs}";
			}
		}
		print POUT "\n";
	}
	return $sample;

}


sub outputMap{
	my @ss = keys %genotype;
	foreach $rs (sort (keys %{$genotype{$ss[0]}} )) {
		if ($map{$rs}) {
			print MOUT $map{$rs}, "\n";
		}
	}
}