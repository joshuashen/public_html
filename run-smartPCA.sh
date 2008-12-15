#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#

bfile=$1   ## user provided 

#hard-code illumina 1m map data:
snpname="/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/illumina1M.pedsnp"

## it would be better to set this in .bash_profile or .bash_rc
path=${PATH}:~/Software/eigensoft/2.0/bin/

echo $bfile
newSNPname=$bfile.bim.SNPs.pedsnp

awk '{print $2}' $bfile.bim > $bfile.bim.SNPs
fgrep -f $bfile.bim.SNPs $snpname -w > $newSNPname


par=${bfile}"_eigen_convf.par"
genotypename=${bfile}"_eigen.ped"
indivname=${bfile}"_eigen.pedid"
pcaout=${bfile}"_eigen.pca"

plotout=${bfile}"_eigen.plot"
evaloutname=${bfile}"_eigen.eval"

logfile=${bfile}"_eigen.log"
phenotype=$bfile"_eigen.pheno"
eigenout=$bfile"_eigen.chisq"
eigengeno=$bfile"_eigen.geno"

# if [ -s ${genotypename} ] && [ -s ${indivname} ]; then
#    echo "skip PLINK commands"
# else
    plink --bfile ${bfile} --out ${bfile} --recode  --transpose
    gawk '/^NA/{print $1,$2,$3,$4,$5,2}!/^NA/{print $1,$2,$3,$4,$5,1}' ${bfile}.tfam > tmp1345; mv tmp1345 ${bfile}.tfam
    plink --tped ${bfile}.tped --tfam ${bfile}.tfam  --out ${bfile} --recode  
    gawk '!/^#/{gsub(/[DI]/,"0"); print}' ${bfile}.ped > ${genotypename}
    
    cp ${bfile}.tfam ${indivname}
# fi

~/Software/eigensoft/2.0/bin/smartpca.perl -i ${genotypename} -a ${newSNPname} -b ${indivname} -o ${pcaout} -p ${plotout} -e ${evaloutname} -l ${logfile}

perl ~/script/fam_to_pheno_for_eigenstrat.pl $bfile.fam > $phenotype
 
echo $genotypename "convert to eigenstrat format"

## should separate SNPs according to chromosomes, do it in a loop, them merge. 

echo -e "genotypename:\t"${genotypename} > ${par}
echo -e "snpname:\t"${newSNPname} >> ${par}
echo -e "indivname:\t"${indivname} >> ${par}
echo -e "outputformat:\tEIGENSTRAT" >> ${par}
echo -e "genotypeoutname:\t"${eigengeno} >> ${par}

~/Software/eigensoft/2.0/bin/convertf -p ${par}

perl ~/Software/eigensoft/2.0/bin/eigenstrat.big.perl -i ${eigengeno} -j ${phenotype} -p ${pcaout} -l 10 -o ${eigenout}

 
date
