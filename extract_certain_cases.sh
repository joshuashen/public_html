## give a large set of cases and controls, extract certain cases with all controls

cases=$1
all=$2
prefix=$3

awk '{if($6==1) print $0}' $all.fam > $all.fam.controls
cat $cases $all.fam.controls > $prefix.list

plink --bfile $all --keep $prefix.list --geno 0.05 --maf 0.01 --mind 0.1 --hwe 0.0000001 --make-bed --out $prefix 

plink --bfile $prefix --assoc --adjust --out $prefix"_assoc"

plink --bfile $prefix --model --out $prefix"_model"



