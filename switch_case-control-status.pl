## 

use strict;
use Getopt::Long;
use vars qw /$opt_help $opt_list/;

GetOptions("help|h", "list|l=s");

if($opt_help || !$opt_list) {
    &help();
    exit;
}

my (%names, $flag);

&getList($opt_list);

while(<>) {
    my $line = $_;
    my @cols = split(/\s+/, $line);
    if ($names{$cols[0]}) { # switch
	if ($cols[5] eq '1') {
	    $flag = "2";
	}else {
	    $flag = "1";
	}
	  
	print $cols[0]," ",$cols[1]," ",$cols[2]," ",$cols[3]," ",$cols[4]," ",$flag,"\n";
    } else {
	print $line;
    }
	
}

## 
sub help {
    print "Usage: perl __.pl -l list  input > output \n";
}

sub getList {
    my $f = shift;
    open(IN, $f) or die("bad file $f\n");
    while(<IN>) {
	if(/^(\S+)/) {
	    $names{$1} = 1;
	}
    }
    close(IN);
    return;
}
