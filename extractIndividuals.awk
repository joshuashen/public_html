# Awk script to extratct data for indidividuals from original Illumina files
# keeps the Illumina name for the individuals.
BEGIN{
	if(dir=="")
		dir = "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/Genotypes/test/"
	dat = 0
	header = ""
	oldID = ""
}
# change the number of samples since we are now only plotting one per individual
/^Num Samples/{
	$0 = "Num Samples,1"
}
{
	if(dat==0){
		header = header "\n" $0
	}else{
		split($0,a,",")
		id = a[2]
		if(id != oldID){
			close(fp)
			fp = dir id ".csv"
			print fp
			print header > fp
		}
		oldID = id
		print "fp:"  fp " dir:" dir " id:" id
		print $0
		print $0 >> fp

	}
}


/^\[Data\]/{
	dat = 1
	getline
	header = header "\n" $0
	print header
}

END{
	print header
}
