# input: ped prefix and output prefix

use Getopt::Long;
use vars qw/$opt_help $opt_ped $opt_bed $opt_output/;

$opt_output = "single_chr";

GetOptions(
           "help|h", "ped|p=s", "bed|b=s", "output|o=s"
	   );

if ($opt_help || (!($opt_ped) && !($opt_bed)  ) ){
    &usage();
    exit;
}

my %chr;
if ($opt_ped) {
    $map = $opt_ped.'.map';
## get chromosome list
    open(IN, "$map") || die("Cannot open .map file\n");
    while(<IN>) {
	if (/^(\S+)\s+/) {
	    $chr{$1} = 1;
	}
    }
    close(IN);
    
    foreach $chromosome ( sort keys %chr) {
	$cmd = "plink --file $opt_ped --chr $chromosome --recode --out $opt_output\_chr\_$chromosome";
	print $cmd, "\n";
	system($cmd);
    }
} elsif ($opt_bed) {
    $bim = $opt_bed.".bim";
    open(IN, "$bim") || die("Cannot open .bim file\n");
    while(<IN>) {
	if (/^(\S+)\s+/) {
            $chr{$1} = 1;
        }
    }
    foreach $chromosome ( sort keys %chr) {
        $cmd = "plink --bfile $opt_bed --chr $chromosome --recode --out $opt_output\_chr\_$chromosome";
        print $cmd, "\n";
        system($cmd);
    }
}

sub usage {
    print STDERR "Usage: perl __.pl -p prefix_of_ped/map [or -b prefix_of_bed/etc] -o prefix_of_output\n" ;
    return;
}
