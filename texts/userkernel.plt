set terminal png size 800,500 enhanced font "Helvetica,20"
set output 'userkernel.png'

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set style data histogram
set style fill solid
set boxwidth 0.9
set logscale y 4
set key autotitle columnhead
set xlabel "Queries per second"
set ylabel "Latencies/ms"

set title "User/kernel space time under different loads"
plot "userkernel.dat" using 2:xtic(1) title "Kernel space" linecolor rgb red, \
	'' using 3 title "User space" linecolor rgb blue
