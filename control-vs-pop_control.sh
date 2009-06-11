## wrapper to do control vs pop controls

original=$1
combined=$2

echo "original cases and controls: " $original
echo "combined set: "$combined 
### steps :
# 1. combine and do plink
# 2. combine matched controls with popcontrols and do plink
# 3. combine statistics

echo "combine the controls and do c vs c"

# get the SNP list 
awk '{if($6==1) print $1}' $original.fam > $original.fam.controls_FID 
awk '{if($6==1) print $0}' $combined.fam > $combined.fam.controls

plink --bfile $combined --keep $combined.fam.controls --make-bed --out $combined.fam.controls_cvc 

# change the phenotype status from 1 to 2 (control to case) for all matched controls 

perl ~/script/change-phenotype-for-matched_controls.pl $original.fam.controls_FID $combined.fam.controls_cvc.fam > temp.fam

rm $combined.fam.controls_cvc.fam
mv temp.fam $combined.fam.controls_cvc.fam 

plink --bfile $combined.fam.controls_cvc  --fisher --adjust --out $combined.fam.controls_cvc_fisher


 

