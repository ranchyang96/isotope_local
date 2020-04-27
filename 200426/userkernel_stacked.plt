set terminal png size 800,500 enhanced font "Helvetica,20"
set output 'userkernel_stacked.png'

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";

set key autotitle columnhead
set title "Latencies in proxy layer and non-proxy part"

set key samplen 4 spacing 1.2 font ",22"

set termoption enhanced
set style histogram rowstacked title offset 0,-1
set bmargin 5

set xtics border in scale 1,0.5 nomirror norotate autojustify
set ytics border in scale 1,0.5 nomirror norotate autojustify
set tics in
set xtics nomirror
set ytics nomirror
set mxtics 10
set style data histograms
set style histogram rowstacked
set style fill solid 0.75 border -1
set boxwidth 0.5
set datafile separator " "
set xlabel "Queries per second"
set ylabel "Latencies/ms"
plot "userkernel.dat" using 2:xtic(1) title "kernel" linecolor rgb blue, \
	'' using 3 title "user" linecolor rgb red
