prefix=$1
out=$2

awk '{if(($1==2 && $4 > 135600000 && $4 < 136600000) || ($1==6 && $4>28000000 && $4 < 33000000) || ($1==8 && $4 > 8000000 && $4 < 12000000) || ($1==17 && $4 > 38000000 && $4 < 41900000)) print $$2}' $prefix.bim > $prefix".bim.tobe-rm"

plink --bfile $prefix --exclude $prefix".bim.tobe-rm" --make-bed --out $out

