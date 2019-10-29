#!/bin/bash
qpses=( 2 8 32 128 )
for testtype in _ack _in
do
	for machine in 04 05 06
	do
		for qps in "${qpses[@]}"
		do
			infl="./texts/org"
			outfl="./texts/flt"
			add="$testtype"
			add+="$machine"
			add+="qps"
			add+="$qps"
			add+=".txt"
			infl+=$add
			outfl+=$add
			awk -F' +|:' '
			BEGIN {
				a["192.168.97.79"]=""
			}
			{
				if ($2 in a || $5 in a)
					print $0
			}' $infl > $outfl
		done
	done
done
for machine in 04 05 06
do
	for qps in "${qpses[@]}"
	do
		infl="./texts/flt_in"
		ackfl="./texts/flt_ack"
		resfl="./texts/flt_res"
		add="$machine"
		add+="qps"
		add+="$qps"
		add+=".txt"
		infl+=$add
		ackfl+=$add
		resfl+=$add
		rm $resfl
		touch $resfl
		echo 'tcpack.py results:' >> $resfl
		awk 'BEGIN{for(i=9;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
			{for(i=9;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
			END {for (i=9;i<=NF;i++) {\
			printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
			}' $ackfl >> $resfl

		echo 'tcpin.py results:' >> $resfl
		awk 'BEGIN{for(i=7;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
			{for(i=7;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
			END {for (i=7;i<=NF;i++) {\
			printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
			}' $infl >> $resfl
	done
done
#############################################
# for pod latencies
#for testtype in _ack _in
#do
#	for machine in 04 05 06
#	do
#		for qps in "${qpses[@]}"
#		do
#			infl="./texts/org"
#			outfl="./texts/flt"
#			add="$testtype"
#			add+="$machine"
#			add+="qps"
#			add+="$qps"
#			add+=".txt"
#			infl+=$add
#			outfl+=$add
#			awk -F' +|:' '
#			BEGIN {
#				a["192.168.90.194"]=""
#				a["192.168.90.195"]=""
#				a["192.168.90.196"]=""
#				a["192.168.90.197"]=""
#				a["192.168.90.198"]=""
#				a["192.168.90.199"]=""
#			}
#			{
#				if ($2 in a || $5 in a)
#					print $0
#			}' $infl > $outfl
#		done
#	done
#done
#for machine in 04 05 06
#do
#	for qps in "${qpses[@]}"
#	do
#		infl="./texts/flt_in"
#		ackfl="./texts/flt_ack"
#		resfl="./texts/flt_res"
#		add="$machine"
#		add+="qps"
#		add+="$qps"
#		add+=".txt"
#		infl+=$add
#		ackfl+=$add
#		resfl+=$add
#		rm $resfl
#		touch $resfl
#		echo 'tcpack.py results:' >> $resfl
#		awk 'BEGIN{for(i=9;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
#			{for(i=9;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
#			END {for (i=9;i<=NF;i++) {\
#			printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
#			}' $ackfl >> $resfl
#
#		echo 'tcpin.py results:' >> $resfl
#		awk 'BEGIN{for(i=7;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
#			{for(i=7;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
#			END {for (i=7;i<=NF;i++) {\
#			printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
#			}' $infl >> $resfl
#	done
#done
###############################################
# for running experiment
#for qps in "${qpses[@]}"
#do
#	./rcmd.py $qps
#done
###############################################
# mixed information
#for testtype in _ack _in
#do
#	for machine in 04 05 06
#	do
#		for qps in "${qpses[@]}"
#		do
#			infl="./texts/org"
#			outfl="./texts/flt"
#			add="$testtype"
#			add+="$machine"
#			add+="qps"
#			add+="$qps"
#			add+=".txt"
#			infl+=$add
#			outfl+=$add
#			awk -F' +|:' '
#			BEGIN {
#				a["172.16.20.101"]=""
#				a["172.16.20.102"]=""
#				a["172.16.20.103"]=""
#				a["192.168.90.194"]=""
#				a["192.168.90.195"]=""
#				a["192.168.90.196"]=""
#				a["192.168.90.197"]=""
#				a["192.168.90.198"]=""
#				a["192.168.90.199"]=""
#				a["192.168.97.71"]=""
#				a["192.168.97.72"]=""
#				a["192.168.97.79"]=""
#				a["192.168.97.70"]=""
#				a["192.168.97.74"]=""
#				a["192.168.97.80"]=""
#				a["192.168.97.73"]=""
#				a["192.168.252.4"]=""
#			}
#			{
#				if ($2 in a || $5 in a)
#					print $0
#			}' $infl > $outfl
#		done
#	done
#done
#for machine in 04 05 06
#do
#	for qps in "${qpses[@]}"
#	do
#		infl="./texts/flt_in"
#		ackfl="./texts/flt_ack"
#		resfl="./texts/flt_res"
#		add="$machine"
#		add+="qps"
#		add+="$qps"
#		add+=".txt"
#		infl+=$add
#		ackfl+=$add
#		resfl+=$add
#		rm $resfl
#		touch $resfl
#		echo 'tcpack.py results:' >> $resfl
#		awk 'BEGIN{for(i=9;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
#			{for(i=9;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
#			END {for (i=9;i<=NF;i++) {\
#			printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
#			}' $ackfl >> $resfl
#
#		echo 'tcpin.py results:' >> $resfl
#		awk 'BEGIN{for(i=7;i<=NF;i++) {max[i]=0; min[i]=1000000000000000000000}} \
#			{for(i=7;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2; if ($i<min[i]) min[i]=$i; if ($i>max[i]) max[i]=$i}} \
#			END {for (i=7;i<=NF;i++) {\
#			printf "%f %f %f %f\n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR), max[i], min[i]}\
#			}' $infl >> $resfl
#	done
#done
