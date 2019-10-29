#!/bin/bash

dir="/home/ubuntu/results/$1_$2_$3_$4_$5_$6_$7_$8"

mkdir $dir

cp /usr/local/bcc/tcpack $dir/
cp /usr/local/bcc/tcpin $dir/

touch $dir/result.txt
echo 'tcpack.py results:' >> $dir/result.txt
awk 'BEGIN{for(i=9;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
	{for(i=9;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
	END {for (i=9;i<=NF;i++) {\
	printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
	}' $dir/tcpack >> $dir/result.txt

echo 'tcpin.py results:' >> $dir/result.txt
awk 'BEGIN{for(i=7;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
	{for(i=7;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
	END {for (i=7;i<=NF;i++) {\
	printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
	}' $dir/tcpin >> $dir/result.txt
