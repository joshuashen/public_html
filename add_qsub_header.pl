## 

$input = shift;

print "#!/bin/bash \n\#\$ \-cwd\n";

system("cat $input");

