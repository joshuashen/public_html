$a  = "  aa ";

$b = &strip($a);
print $b, "^^^\n";

sub strip {
    my $s = shift;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    return $s;
}
