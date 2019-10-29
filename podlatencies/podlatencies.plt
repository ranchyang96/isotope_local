set terminal png size 800,500 enhanced font "Helvetica,20"
set output 'podlatencies.png'

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set style data histogram
set style fill solid
set boxwidth 0.9
#set logscale y 4
set xlabel "Queries per second"
set ylabel "Latencies/ms"

set title "Latencies under different loads"
plot "podlatencies.dat" using 2:xtic(1) title "Total" linecolor rgb red, \
	'' using 3 title "MAC" linecolor rgb blue, \
	'' using 4 title "IP" linecolor rgb green, \
	'' using 5 title "TCP" linecolor rgb skyblue
