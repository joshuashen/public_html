#!/home/hgsc/bin/perl -w
use Getopt::Long;
use strict;
use vars qw /$opt_help $opt_file $opt_exclude $opt_col $opt_name/; 

$opt_col = 0;

GetOptions("help|h", "file|f=s", "exclude|e", "col|c=i", "name|n=s");

if($opt_help || (!$opt_file  && !$opt_name )) {
    print "Usage: perl __.pl -f wordlist.file original.file [-e] [> output]\n";
    exit;
}

my (%word, $flag, $line, @cols);

if ($opt_file) {
    open (IN, "$opt_file") or die ("bad $opt_file\n");
    while(<IN>) {
	if(/^(\S+)/) {
	    $word{$1}++;
	}
    }
    close(IN);
} elsif ($opt_name) {
    print STDERR "$opt_name\n";
    $word{$opt_name} = 1;
}

print STDERR "list loaded\n";

while(<>) {
    my $line = $_;
#    print STDERR $line;
    
    chomp($line);
    
    $flag=0;
    @cols = split(/\s+/, $line);
    
    if($opt_exclude) {
	if ( exists $word{$cols[$opt_col]} and $word{$cols[$opt_col]} > 0) {
	    $flag=0;
	    
	} else {
	    $flag=1;
	}
    } else {
	if ( exists  $word{$cols[$opt_col]} and $word{$cols[$opt_col]} > 0 ) {
	    $flag=1;
	    
	}
    }

    if ($flag==1) {
	print "$line\n";
    }
}
