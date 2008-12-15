## search for functional SNPs in LD

snp=$1
chr=$2

grep $snp -w ${HOME}"/HapMap/LD/ld_chr"$chr"_CEU.txt"  > $snp"_LD.txt"
awk '{print $4"\n"$5}' $snp"_LD.txt" | sort -u > $snp"_LD.txt.rs"
fgrep -f $snp"_LD.txt.rs" -w ~/HapMap/dbSNP.annotation > $snp"_LD.txt.rs.Annotation"


