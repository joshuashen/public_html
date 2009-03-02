#!/bin/bash

#$ -cwd

assoc=$1
model=$2


`awk '{print $2,$3}' $assoc > $assoc.pos`

`head -1 $model > $model.trend`
`grep TREND $model >> $model.trend`
`/ifs/home/c2b2/ip_lab/yshen/usr/local/bin/ruby /ifs/home/c2b2/af_lab/saec/script/test/add_position_to_model.rb $assoc.pos $model.trend > $model.trend.pos`

`/nfs/apollo/1/shares/software/core_facility/local/x86_64_rocks/R/current/bin/Rscript /ifs/home/c2b2/af_lab/saec/script/manhattan_plot.R $model.trend.pos`

`/nfs/apollo/1/shares/software/core_facility/local/x86_64_rocks/R/current/bin/Rscript /ifs/home/c2b2/af_lab/saec/script/qqplot_chisq.R $model.trend.pos`

