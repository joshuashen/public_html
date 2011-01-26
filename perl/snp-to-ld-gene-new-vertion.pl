
use strict;
use Getopt::Long;

use vars qw/$opt_help $opt_gene_to_snp $opt_snplist $opt_ld $opt_minrsq/ ;
my (%proxies, %pvalues , %snplist);

$opt_minrsq = 0.5; # min rsq

GetOptions("help|h", "gene_to_snp|g=s", "ld|s=s" ,"minrsq|m=f", "snplist|l=s");

if ($opt_help || !$opt_gene_to_snp || !$opt_snplist || !$opt_ld) {
    &help();
    exit;
}

# read the snps file
&looksnps();
&assignldSNPs ();
&assignGenes ();

exit;

#sub routine
#### -----
sub help {
    print STDERR "no help for now";
}

sub looksnps {
    my ($rs,$p);
    open GIN, "$opt_snplist" || die("Bad gene file\n");
    while(<GIN>) {
	if (/^(rs\d+)\s+(\S+)/)  {
            $rs = $1;
	    $p = $2;

	    $pvalues{$rs} = $p;
       ##    %snpgenelist{$rs}= &searchgene
      }
	
    }
    close(GIN);
    my $num = scalar keys %pvalues;
    #print STDERR "Number of SNPs loaded: $num\n";
    return;
}
#assign LD-snps each SNP


sub assignldSNPs {
    my ($rs1, $rs2, $rsq);
    open IN, "$opt_ld" || die("Bad SNP file\n");
    while(<IN>) {
# pattern match for each line
	
## 	if (/^\s+(\d+)\s+(\d+)\s+(rs\d+)\s+(\d+)\s+(\d+)\s+(r\s\d+)\s+(\d\.\d+)\s*\n/) {
 	if (/^\s+(\d+)\s+(\d+)\s+(rs\d+)\s+(\d+)\s+(\d+)\s+(rs\d+)\s+(\S+)/) {
	    $rs1 = $3;
	    $rs2 = $6;
	    $rsq = $7;
	    


# my @ldsnplist=&search($rs1,$rs2,$rsq);
	    if ($rsq >= $opt_minrsq && exists $pvalues{$rs1}) {
	#	print STDERR "$rs1\t$rs2\t$rsq\n\n";
		$proxies{$rs1}{$rs2} = $rsq;
		#$proxies{$rs2}{$rs1} = $rsq;
	    }
	}
    }
    close(IN);
    return;
}

sub assignGenes {
    my ($snp, $rs, $chr, $pos, $gene);
    open IN, "$opt_gene_to_snp" || die("Bad snp to gene mapping\n");
    while(<IN>) {
	if(/^(rs\d+)\s+(\d+)\s+(\d+)\s+(\S+)\s+(\d+)\s+(\d+)/){
	    $rs = $1;
	    $chr = $2;
	    $pos = $3;
	    $gene = $4;

	    if (exists $proxies{$rs}) {
#		print STDERR "$rs\n";
		foreach my $snp (keys %{$proxies{$rs}}) {
		    my $minpvalue = 1.0;
		#    if (exists $pvalues{$rs} && exists $pvalues{$snp} ) { # both SNPs are on chip
		#	# take the smaller p-value
		#	$minpvalue = $pvalues{$rs};
		#	if ($pvalues{$snp} < $minpvalue) {
		#	    $minpvalue = $pvalues{$snp};
		#	}
		#    } elsif (exists $pvalues{$rs}) {  # only $rs is on chip
		#	$minpvalue = $pvalues{$rs};
		#    } elsif (exists $pvalues{$snp}) { # only $snp is on chip
		#	$minpvalue = $pvalues{$snp};
		#	
		#    }
			# print the pvalue
		    print "$snp\t$rs\t$minpvalue\t$gene\t$proxies{$rs}{$snp}\n";
		   		   
		}
	    }
        }
    }
    close(IN);
    return;
}
