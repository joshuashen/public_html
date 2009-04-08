#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#

bfile=$1   ## user provided 

plink=${HOME}"/Software/plink-1.04-x86_64/plink"

#hard-code illumina 1m map data:
snpname="/ifs/home/c2b2/af_lab/saec/SJS/usr/ys/data/illumina1M.pedsnp"
##  "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/illumina1M.pedsnp"

## it would be better to set this in .bash_profile or .bash_rc
path=${PATH}:${HOME}/Software/eigensoft/2.0/bin/

echo $bfile
newSNPname=$bfile.bim.SNPs.pedsnp

awk '{print $2}' $bfile.bim > $bfile.bim.SNPs
fgrep -f $bfile.bim.SNPs $snpname -w > $newSNPname


par=${bfile}"_eigen_convf.par"
smartPCAPar=${bfile}"_eigen_smartPCA.par"
genotypename=${bfile}"_eigen.ped"
indivname=${bfile}"_eigen.pedid"
pcaout=${bfile}"_eigen.pca"
componentOut=${bfile}"_eigen.pca.components"
plotout=${bfile}"_eigen.plot"
evaloutname=${bfile}"_eigen.eval"
evecoutname=${bfile}"_eigen.pca.evec"
logfile=${bfile}"_eigen.log"
phenotype=$bfile"_eigen.pheno"
eigenout=$bfile"_eigen.chisq"
eigengeno=$bfile"_eigen.geno"

# if [ -s ${genotypename} ] && [ -s ${indivname} ]; then
#    echo "skip PLINK commands"
# else
tfile=${bfile}"_t"
    ${plink} --bfile ${bfile} --out ${tfile} --recode  --transpose
    gawk '/^NA/{print $1,$2,$3,$4,$5,2}!/^NA/{print $1,$2,$3,$4,$5,1}' ${tfile}.tfam > tmp1345; mv tmp1345 ${tfile}.tfam
    ${plink} --tped ${tfile}.tped --tfam ${tfile}.tfam  --out ${tfile} --recode  
    gawk '!/^#/{gsub(/[DI]/,"0"); print}' ${tfile}.ped > ${genotypename}
    
    cp ${tfile}.tfam ${indivname}


echo -e "genotypename:\t"${genotypename} > ${smartPCAPar}
echo -e "snpname:\t"${newSNPname} >> ${smartPCAPar}
echo -e "indivname:\t"${indivname} >> ${smartPCAPar}
echo -e "evecoutname:\t"${evecoutname} >> ${smartPCAPar}
echo -e "evaloutname:\t"${evaloutname} >> ${smartPCAPar}
echo -e "altnormstyle:\tNO" >> ${smartPCAPar} 
echo -e "numoutevec:\t10" >> ${smartPCAPar}
echo -e "numoutlieriter:\t5" >> ${smartPCAPar}
echo -e "numoutlierevec:\t10" >> ${smartPCAPar}
echo -e "outliersigmathresh:\t6" >> ${smartPCAPar}
echo -e "genotypeoutname:\t"${eigengeno} >> ${smartPCAPar}
echo -e "snpweightoutname:\t"${componentOut} >> ${smartPCAPar}


${HOME}/Software/eigensoft/2.0/bin/smartpca -p ${smartPCAPar}

# {$HOME}/Software/eigensoft/2.0/bin/smartpca.perl -i ${genotypename} -a ${newSNPname} -b ${indivname} -o ${pcaout} -p ${plotout} -e ${evaloutname} -l ${logfile}

# perl ~/script/fam_to_pheno_for_eigenstrat.pl $bfile.fam > $phenotype
 
echo $genotypename "convert to eigenstrat format"

## should separate SNPs according to chromosomes, do it in a loop, them merge. 

echo -e "genotypename:\t"${genotypename} > ${par}
echo -e "snpname:\t"${newSNPname} >> ${par}
echo -e "indivname:\t"${indivname} >> ${par}
echo -e "outputformat:\tEIGENSTRAT" >> ${par}
echo -e "genotypeoutname:\t"${eigengeno} >> ${par}

# ~/Software/eigensoft/2.0/bin/convertf -p ${par}

# perl ~/Software/eigensoft/2.0/bin/eigenstrat.big.perl -i ${eigengeno} -j ${phenotype} -p ${pcaout} -l 10 -o ${eigenout}

 
date
