#!/bin/bash

#$ -cwd

prefix=$1  # prefix of the binary genotype file
plink=${HOME}"/Software/plink-1.04-x86_64/plink"

# call rate: > 90%


# sample relatedness: pi_hat 

$plink --bfile $prefix --hwe 0.0000001 --genome --out $prefix"_genome"

$plink --bfile $prefix --hwe 0.0000001 --read-genome $prefix"_genome.genome" --cluster --mds-plot 10 --out $prefix"_mds"




