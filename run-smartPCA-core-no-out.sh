#!/bin/bash
#
#$ -cwd

bfile=$1   ## user provided 
plink=${HOME}"/Software/plink-1.06-x86_64/plink"

#hard-code illumina 1m map data:
snpname="/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/Illumina1M/illumina1M.sorted.map"

## SNP recomputed for PCA
pcaSNPs="/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/SNPs-for-PCA.list"

## it would be better to set this in .bash_profile or .bash_rc
path=${PATH}:${HOME}/Software/eigensoft/2.0/bin/

echo $bfile





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

twstats=$bfile"_eigen.pca.twstats"

newSNPname=$bfile.bim.SNPs.pedsnp

tfile=${bfile}"_t"
${plink} --bfile ${bfile} --extract ${pcaSNPs} --out ${tfile} --recode

gawk '!/^#/{gsub(/[DI]/,"0"); print}' ${tfile}.ped > ${genotypename}


awk '{print $2}' $tfile.map > $tfile.map.SNPs
fgrep -f $tfile.map.SNPs $snpname -w > $newSNPname

## make indiv file
# case
cp ${tfile}.fam ${indivname}


echo -e "genotypename:\t"${genotypename} > ${smartPCAPar}
echo -e "snpname:\t"${newSNPname} >> ${smartPCAPar}
echo -e "indivname:\t"${indivname} >> ${smartPCAPar}
echo -e "evecoutname:\t"${evecoutname} >> ${smartPCAPar}
echo -e "evaloutname:\t"${evaloutname} >> ${smartPCAPar}
echo -e "altnormstyle:\tNO" >> ${smartPCAPar} 
echo -e "numoutevec:\t10" >> ${smartPCAPar}
echo -e "numoutlieriter:\t0" >> ${smartPCAPar}
echo -e "genotypeoutname:\t"${eigengeno} >> ${smartPCAPar}
echo -e "snpweightoutname:\t"${componentOut} >> ${smartPCAPar}


${HOME}/Software/eigensoft/2.0/bin/smartpca -p ${smartPCAPar}
${HOME}/Software/eigensoft/2.0/bin/twstats -t ${HOME}/Software/eigensoft/2.0/POPGEN/twtable -i ${evaloutname} -o ${twstats}

