set terminal png size 800,500 enhanced font "Helvetica,20"
set output '05latencies.png'

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set style data histogram
#set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
#set xtics format ""
#set grid ytics

set title "Latencies under different loads"
plot "../texts/05latencies.dat" using 2:xtic(1) title "Total" linecolor rgb red, \
	'' using 3 title "MAC" linecolor rgb blue, \
	'' using 4 title "IP" linecolor rgb green, \
	'' using 5 title "TCP" linecolor rgb skyblue
