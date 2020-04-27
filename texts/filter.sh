#!/bin/bash
cat org_ack04qps.txt org_ack05qps.txt org_ack06qps.txt > ack.txt
cat org_in04qps.txt org_in05qps.txt org_in06qps.txt > in.txt
sort -n -k 7 in.txt > sorted_in.txt
sort -n -k 23 ack.txt > sorted_ack.txt
awk -F ' +|:' '{ if ($5 == "10.36.0.6") print $2,$3,$5,$6,$9,$10 }' sorted_in.txt > producpage_in.txt
awk -F ' +|:' '{ if ($5 == "10.36.0.7") print $2,$3,$5,$6,$9,$10 }' sorted_in.txt > details_in.txt
awk -F ' +|:' '{ if ($5 == "10.44.0.5") print $2,$3,$5,$6,$9,$10 }' sorted_in.txt > ratings_in.txt
awk -F ' +|:' '{ if ($5 == "10.36.0.5") print $2,$3,$5,$6,$9,$10 }' sorted_in.txt > reviews1_in.txt
awk -F ' +|:' '{ if ($5 == "10.44.0.4") print $2,$3,$5,$6,$9,$10 }' sorted_in.txt > reviews2_in.txt
awk -F ' +|:' '{ if ($5 == "10.36.0.8") print $2,$3,$5,$6,$9,$10 }' sorted_in.txt > reviews3_in.txt
awk -F ' +|:' '{ if ($2 == "10.36.0.6") print $2,$3,$5,$6,$25,$12,$13 }' sorted_ack.txt > producpage_ack.txt
awk -F ' +|:' '{ if ($2 == "10.36.0.7") print $2,$3,$5,$6,$25,$12,$13 }' sorted_ack.txt > details_ack.txt
awk -F ' +|:' '{ if ($2 == "10.44.0.5") print $2,$3,$5,$6,$25,$12,$13 }' sorted_ack.txt > ratackgs_ack.txt
awk -F ' +|:' '{ if ($2 == "10.36.0.5") print $2,$3,$5,$6,$25,$12,$13 }' sorted_ack.txt > reviews1_ack.txt
awk -F ' +|:' '{ if ($2 == "10.44.0.4") print $2,$3,$5,$6,$25,$12,$13 }' sorted_ack.txt > reviews2_ack.txt
awk -F ' +|:' '{ if ($2 == "10.36.0.8") print $2,$3,$5,$6,$25,$12,$13 }' sorted_ack.txt > reviews3_ack.txt
