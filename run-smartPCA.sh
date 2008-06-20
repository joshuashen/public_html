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


par="par_"${bfile}
genotypename=${bfile}"_eigen.ped"
indivname=${bfile}"_eigen.pedid"
pcaout=${bfile}"_eigen.pca"
## evecoutname=${bfile}"_eigen.evec"
plotout=${bfile}"_eigen.plot"
evaloutname=${bfile}"_eigen.eval"
## snpweightoutname=${bfile}"_eigen.components"
logfile=${bfile}"_eigen.log"

if [ -s ${genotypename} ] && [ -s ${indivname} ]; then
    echo "skip PLINK commands"
else
    plink --bfile ${bfile} --out ${bfile} --recode  --transpose
    gawk '/^NA/{print $1,$2,$3,$4,$5,2}!/^NA/{print $1,$2,$3,$4,$5,1}' ${bfile}.recode.tfam > tmp1345; mv tmp1345 ${bfile}.recode.tfam
    plink --tped ${bfile}.recode.tped --tfam ${bfile}.recode.tfam  --out ${bfile} --recode  
    gawk '!/^#/{gsub(/[DI]/,"0"); print}' ${bfile}.recode.ped > ${genotypename}
    
    cp ${bfile}.recode.tfam ${indivname}
fi

~/Software/eigensoft/2.0/bin/smartpca.perl -i ${genotypename} -a ${snpname} -b ${indivname} -o ${pcaout} -p ${plotout} -e ${evaloutname} -l ${logfile}
 

# echo -e "genotypename:\t"${genotypename} > ${par}
# echo -e "snpname:\t"${snpname} >> ${par}
# echo -e "indivname:\t"${indivname} >> ${par}
# echo -e "evecoutname:\t"${evecoutname} >> ${par}
# echo -e "evaloutname:\t"${evaloutname} >> ${par}
# echo -e "altnormstyle:\tNO" >> ${par}
# echo -e "numoutevec:\t10"  >> ${par}
# echo -e "snpweightoutname:\t"${snpweightoutname} >> ${par}

# ~/Software/eigensoft/2.0/bin/smartpca -p ${par}

# ~/Software/eigensoft/2.0/bin/smartpca.perl -i ${dataDir}/${filename}-d.ped  -a 

#  ${RCMD} --vanilla  ${scriptDir}/geneticClust.R gpName=$filename


date
