set terminal png size 800,500 enhanced font "Helvetica,20"
set output 'podlatencies_stacked.png'

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";

set title "Latencies under different loads"

set style data histograms
set style histogram rowstacked
set boxwidth 0.5
set style fill solid
set datafile separator " "
set xlabel "Queries per second"
set ylabel "Latencies/ms"
plot "podlatencies.dat" using 3 title "MAC" linecolor rgb blue, \
	'' using 4 title "IP" linecolor rgb green, \
	'' using 5 title "TCP" linecolor rgb red
