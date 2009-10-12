#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#

oriBfile=$1   ## user provided 

plink=${HOME}"/Software/plink-1.04-x86_64/plink"

#hard-code illumina 1m map data:
snpname="/ifs/home/c2b2/af_lab/saec/SJS/usr/ys/data/illumina1M.pedsnp"
##  "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/illumina1M.pedsnp"

## SNPs in long LD regions
SNPsinlongLD="/ifs/home/c2b2/af_lab/saec/PopulationControls/PCA/SNPs-in-long-LD.list-Illumina-1M-Duo.rs"

## it would be better to set this in .bash_profile or .bash_rc
path=${PATH}:${HOME}/Software/eigensoft/2.0/bin/


bfiletemp=${oriBfile}"-4-PCA-temp"
bfile=${oriBfile}"-4-PCA"

# remove SNPs in long-LD region and prune 
${plink}  --bfile ${oriBfile} --exclude ${SNPsinlongLD} --indep-pairwise 1500 150 0.2 --out ${bfiletemp}
${plink} --bfile ${oriBfile} --extract  ${bfiletemp}".prune.in" --make-bed --out ${bfile}


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

twstats=$bfile"_eigen.twstats"

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

## significance of eigen vectors

${HOME}/Software/eigensoft/2.0/bin/twstats -t ${HOME}/Software/eigensoft/2.0/POPGEN/twtable -i ${evaloutname} -o ${twstats}