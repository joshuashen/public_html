while(<>) {
   chomp;
   @cols=split(/\s+/, $_);
   if ($cols[-1] eq '2') { # case
        print "1";
   } elsif ($cols[-1] eq '1') { # controls
        print "0";
   } else {
        print "9";
   }
}
print "\n";


