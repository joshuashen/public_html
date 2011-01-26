#!/usr/bin/perl
# Author Paolo Guarnieri, MD & Paola Nicoletti, MD
use strict;
use warnings;
use Getopt::Long;
# Import parameters:
# path where the gen gen files are located
# Master file with actual phenotype pvalues
# Prefix to be used to create output file
# Max number of phenotype runs to be combined
# 
my $Path;
my $OutPath;
my $Prefix;
my $MasterFile;
my $OutFileNamePrefix;
GetOptions ('p=s' => \$Path,
	    'c=s' => \$OutPath,
            'm=s' => \$MasterFile,
            'a=s' => \$Prefix,
            'o=s' => \$OutFileNamePrefix,
                        );
###
#can you access the files
die ("Please provide Path : -p Path\n") unless $Path;
die ("Please provide Master file name : -m Filename") unless $MasterFile;
die ("Please provide Prefix : -a Prefix\n") unless $Prefix;
die ("Please provide output file name without extension : -o Filename\n") unless $OutFileNamePrefix;
die ("Please provide output Path : -c Path\n") unless $OutPath;

# Log file: Output my parameters
open (LOG,">$OutFileNamePrefix\_Cazzosuccede.log") or die "Can't open log file for output\n$!\n";
#make it unbuffered
select(LOG); $| = 1;
#
print "\n\nPARAMETERS\n\nPath:".$Path."\n";
print "Master file:".$MasterFile."\n";
print "Prefix:".$Prefix."\n";
print "Output suffix:".$OutFileNamePrefix."\n\n";
#####
#Global variables:
#my %MasterHash; #hash built on the master file (return of processMaster)
#my %CurrentHash;#hash built on each current file (return of processCurrentfile)
#my @ArrayOfCurrentHashes; #Array of the reference to the CurrentFile hash
#my @ArrayOfMasterHashes; #Array of the reference to the MasterFile hash
#my @RefToListgenes;#Array of the references to the valeu of MasterFile hash

# create dump directory
my $tempDir = "$OutPath/tmpExonR2-$OutFileNamePrefix";
my $outDir = "$OutPath/exonR2-$OutFileNamePrefix";
if (! -e "$tempDir") {
    mkdir("$tempDir") or die "Can't create $tempDir:$!\n";
}
if (! -e "$outDir") {
    mkdir("$outDir") or die "Can't create $outDir:$!\n";
}  
#####
# open the master file and read it line by line. split the cols and take what is needed,
# what is needed is stored in the master hash.
my $MasterHashRef = &ProcessMaster($MasterFile);
#push (@ArrayOfMasterHashes, $MasterHashRef);
print LOG "\t\t\t\tdone\n";  


my $DIRHANDLE;
unless (opendir $DIRHANDLE, $Path) {
    die "Couldn't open $Path.\n$!\nSkipping!";
}

my $Counter = 0; # Count the number of files you processed up to now.
my @FileList = sort(readdir $DIRHANDLE);
foreach  my $CurrentFileName (@FileList) {
    if ($CurrentFileName eq '.' || $CurrentFileName eq '..' || $CurrentFileName !~ m/$Prefix/) {
        print LOG "skipping $CurrentFileName\n";
        next;
    }
    else {
	print LOG "Processing $CurrentFileName\n";
        print LOG "\t Building hash...\n";
	my $CurrentHashRef =&ProcessFile ($CurrentFileName);
	#push (@ArrayOfCurrentHashes, $CurrentHashRef);
        print LOG "\t\t\t\tdone\n";
	my $CurrentOutFileName = $Prefix.$Counter.".txt";
	open (TMP,"> $tempDir/$CurrentOutFileName.TMP") or die "Can't open temp file for writing\n$!";
	print LOG "\tProducing tmp output file: \'$CurrentOutFileName\' ...\n";
	foreach my $CurrentSnpName (keys %{$CurrentHashRef}) {
	    foreach my $SingleGeneName (@{${$MasterHashRef}{$CurrentSnpName}}) {
		my $CurruntPvalue = ${$CurrentHashRef}{$CurrentSnpName}; #build 
		#print LOG "what's in the value for RefCurruntPvalue? $CurruntPvalue\n";
	    	#my @SortedlistPvalue =  sort {$a <=> $b} @{$CurruntPvalue}; # @sorted = sort { $hash{$a} cmp $hash{$b} } keys %hash;
		print TMP "$SingleGeneName\t$CurruntPvalue\n";
		#print LOG "$CurrentSnpName\t${$CurrentHashRef}{$CurrentSnpName}\t$singleGeneName\n";
		#print  "$GeneName\t$SortedlistPvalue[0]\n";
		  
	    }
	}
	close (TMP);
	print LOG "\tdone\n";
	 
	open (OUT,">$outDir/$CurrentOutFileName") or die "Can't open output\n$!";
	# reopen TMP file for reading and post processing to remove duplicate genes
	open (TMP,"$tempDir/$CurrentOutFileName.TMP") or die "Can't open temp file for post process reading\n$!";
	print LOG "\tProducing final output file: \'$CurrentOutFileName\' ...\n";
	my %uniqueGenesAndPvalues ;
	while (my $line = <TMP> ) {
	    my @splittedGenePValue = split /\t/, $line;
	    #assuming 0 = geneName and 1 = pValue
	    if ($uniqueGenesAndPvalues{$splittedGenePValue[0]}) {
		if ($splittedGenePValue[1] < $uniqueGenesAndPvalues{$splittedGenePValue[0]} ) {
		    $uniqueGenesAndPvalues{$splittedGenePValue[0]} = $splittedGenePValue[1];
		}
	    } else {
		$uniqueGenesAndPvalues{$splittedGenePValue[0]} = $splittedGenePValue[1];
	    }
	}
	close (TMP);
	foreach my $uniqueGene (keys %uniqueGenesAndPvalues) {
	    print OUT "$uniqueGene\t$uniqueGenesAndPvalues{$uniqueGene}";
	}
	close (OUT);
	print LOG "\tfinal output done\n";
	system ("rm $tempDir/$CurrentOutFileName.TMP");
	print LOG "\ttmp file delete\n";
	$Counter ++ ;
    }   
}




# Prepare to exit.
close $DIRHANDLE;
system ("rm -rf $tempDir");
print LOG "Execution completed\n";

close (LOG);
exit(0);
#

#
################################################################################
### Subroutines
################################################################################

sub ProcessMaster {
    my %MasterHash; #hash built on the master file (return of processMaster)
    my $MasterFile=shift;
    open (MASTER, "$MasterFile") or die "Can not open master file:$MasterFile\n$!\n";
    print LOG "Starting reading master file...\n";
    my $sink = <MASTER>;
    while (my $currentLine = <MASTER>) {
    my @SplittedLine = split (/\s+/,$currentLine);
        chomp ($SplittedLine[$#SplittedLine]); # remove end of line CR LN
        my $SNP = $SplittedLine[0]; # 
	my $GeneName = $SplittedLine[1];
	#print LOG "$SNP $GeneName";
	push (@{$MasterHash{$SNP}},$GeneName); #Bult an hash which has the " ref to value (genes)" an array as value and the key SNPname assoccieted with the gens
	}   
	foreach my $GeneName (keys %MasterHash) { 
	    #print LOG "what's the key and the value of the hash? it is: $GeneName $MasterHash{$GeneName}\n";	
	    my $RefToListgenes = $MasterHash{$GeneName};	    
	}


    close (MASTER);

    print LOG "\t\t\tdone. Master file is in memory!\n\n";
    #	 get the list of files from the direcotory and skip those not interesting
        
    return \%MasterHash;  
}





sub ProcessFile {
    my $CurrentFileName = shift;
    my %CurrentHash;
    # Create an empty hash to populate with data from current file.
    #my %CurrentHash ;
    # Remember structure;
    # Hash
    # SNPid1->[0] #P
    #     
    open CURRENTFILE, $CurrentFileName or die "Can't open $CurrentFileName\n$!\n";
    my $sink = <CURRENTFILE>; # get rid of header line.
    while (my $currentLine = <CURRENTFILE>) {
        my @SplittedLine = split(/\s+/, $currentLine);
        ##only keep ADD index 4
        #if ($SplittedLine[5] eq "ADD") {
        #    chomp ($SplittedLine[$#SplittedLine]); # remove end of line CR LN
        #    #print LOG "$SplittedLine[2]\t";
            my $CurrentPvalue =	$SplittedLine[1];
	    my $CurrentSnpName = $SplittedLine[0]; # index2 because the splitting with whitespaces introduces an empty element as first (index0)
	    $CurrentHash{$CurrentSnpName} = $CurrentPvalue; # P value (value)assined to snp (key)
            #print LOG "what's the value of the hash? it is: $CurrentHash{$CurrentSnpName}\t";
           
        #}
    }
    close CURRENTFILE;
    # return an HashReference;
    return \%CurrentHash;    
}

