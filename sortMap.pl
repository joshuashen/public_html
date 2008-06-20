#!/usr/bin/perl
## Create PED files for PLINK 
# C:\SAEC\scripts>perl makePED.pl -mapfile mapping_info.txt -snpfile snp_ids.txt -dir ../data -phenofile phenotypes.txt -outfile makePED.out

use Getopt::Long;
use Data::Dumper;
use strict;

my $VERSION = '1_00';
# Check if programm called correctly

# my $snpfp = "/nfs/apollo/2/c2b2/users/saec/SJS/usr/bernd/data/illumina1M.map";
#read in information about which SNPs should be there
# we neeed a complete list of SNPs before we start, so either read in this file or go through all files and make this list
# open(DAT, $snpfp) || die("Could not open file  $snpfp!");
# my @snp_data=<DAT>;
my %snps; #SNP names
# foreach my $m (@snp_data) {
while (<>) {
#	if ($m =~ /^#/) { #ignore comment lines
    my $m=$_;
    if ($m=~ /^\#/)  { # ignore comment lines
	next;
    }
    $m =~ s/[\r\n]//g; #remove end of line characters
    my @a = split(/\t/, $m);
    $snps{$a[1]} = $m;
    #print $m;
}
close(DAT);

if (!defined %snps) {
	print("#%snps not defined");
	die("%snps not defined");
}

foreach my $m (sort keys %snps) {
	print "$snps{$m}\n";
}
