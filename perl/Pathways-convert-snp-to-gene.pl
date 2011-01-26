#!/usr/bin/perl
use strict;
use warnings;

my $InputFileName = shift;
chomp ($InputFileName);
print "$InputFileName\n";

my $OutputFileName = shift;
chomp ($OutputFileName);
print "$OutputFileName\n";

my %GenePvalueHash;
my @ArrayOfHashes;
#my $GeneName;
#my $Pvalue;


open INFILE, "$InputFileName" or die "Can not open input $InputFileName file\n$!\n";
open OUTFILE, ">$OutputFileName" or die "Can not open output $OutputFileName file\n$!\n";
my $sink = <INFILE>;
while(my $CurrentLine = <INFILE>){
    my @CurrentLineSplitted = split (/\s+/, $CurrentLine);
    my $GeneName = $CurrentLineSplitted[3];
    my $Pvalue =$CurrentLineSplitted[2];
        #my $i++;
        #my $Pvalue = {$GenePvalueHash{$GeneName}};
	#my @ArrayOfHashes = ({$GenePvalueHash{$GeneName}});
	#$GenePvalueHash{$GeneName}= $Pvalue;
	push (@{$GenePvalueHash{$GeneName}}, $Pvalue);
	#if ( $Pvalue < $GenePvalueHash{$GeneName}) # && exists $GenePvalueHash{$GeneName}){
	#$Pvalue => values (%GenePvalueHash);
	#print $GeneName{%GenePvalueHash}, $Pvalue{%GenePvalueHash};
	}
#}
#for $ArrayOfHashes ( keys %GenePvalueHash ) {
#    print "$ArrayOfHashes: @{$GenePvalueHash{$ArrayOfHashes}}\n";


	foreach my $GeneName (keys %GenePvalueHash) { # I get each of all keys (genes)of the hash 
	    #print "what's the value of the hash? it is:$GenePvalueHash{$GeneName}\n";	
	    my $RefToListPvalue = $GenePvalueHash{$GeneName}; # the hash's value is a list but it is stored as a scalar so we store the reference (memory address to the list), so I set a variable scalar ($) the variables' list's address
	    #print "@{$RefToListPvalue}\n"; I print all the list
	    #exit;
	    my @SortedlistPvalue =  sort {$a <=> $b} @{$RefToListPvalue}; # I set an array variable conteining all the reference at the array variable sorted as scalar by ascending order;
	    #print "what's in the sorted array? there is:@SortedlistPvalue\n";
	    print OUTFILE "$GeneName\t$SortedlistPvalue[0]\n"; # I print 
    }

close INFILE;
close OUTFILE;
exit(0);

#!/usr/bin/perl
#use strict;
#use warnings;
#
#my $Pvalue = 0.032;
#my $GeneName = "NF1";
#returns the value  corresponding to the $GeneName as key = $GenePvalueHash{$GeneName};
#my %GenePvalueHash;
#for (my $counter = 0 ; $counter <= 100; $counter++) {
#    my $ass;
#    my $RefToListOfPreviousPValues = $GenePvalueHash{$GeneName};
#    if ($RefToListOfPreviousPValues) {
#        my @FusionArray = (@$RefToListOfPreviousPValues,$Pvalue);
#        $GenePvalueHash{$GeneName} = \@FusionArray ; 
#    } else {
#        my @TempArray ;
#        push (@TempArray, $Pvalue);
#        $GenePvalueHash{$GeneName} = \@TempArray ; 
#    }   
#    undef ($ass);
#}

#my @ArrayOfHashes;
#for (my $counter = 0 ; $counter <100;$counter++) {
#    my %Hash ;
#    $Hash{"porcamadonn"} = "Value = $counter";
#    push (@ArrayOfHashes, \%Hash);
#    undef(%Hash);
#}
#
# this operation does the following : Assign $Pvalue VALUE to the value corrisponding to the key $Gene
# AND it also assign the Hash %GenePvalueHash to a new Hash called %GenePvalueHash
#my %Hashname;
#$Hashname{key}= "VALUE";
#[8:38:47 PM] Paolo Guarnieri: versione veloce
#[8:38:49 PM] Paolo Guarnieri: 
#



