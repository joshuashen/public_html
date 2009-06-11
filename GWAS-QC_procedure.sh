prefix=$1

## missingness
plink --bfile $prefix --missing --out $prefix"_missing"

## hwe
plink --bfile $prefix --hardy --out $prefix"_hardy"
