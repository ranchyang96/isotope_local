set datafile separator ","
set terminal postscript eps enhanced color font 'Helvetica,20' linewidth 1 rounded size 12cm,8cm

set border 3 back ls 80

set style line 81 lc rgb "#808080" lt 0 lw 2 dt 3
set grid back ls 81 lw 0.25

set xtics border in scale 1,0.5 nomirror norotate autojustify
set ytics border in scale 1,0.5 nomirror norotate autojustify
set tics in
set xtics nomirror
set ytics nomirror

set key samplen 4 spacing 1.2 font ",22"

set mxtics 10

#set title font ", 16"
set xlabel font ", 16"
set ylabel font ", 16"

set xtics font ", 14"
set ytics font ", 14"
set key font ",14"
set key top right
# set xtics rotate by 30 right
# set key outside offset -10,0
# set key vertical maxrows 1

# set xrange [0:100]
# set yrange [0:100]

# set xlabel "" offset 0,0
# set ylabel "" offset 0,0


# set auto x
# set xtic scale 1
# set style data histogram
# set style histogram cluster gap 1
# set style fill solid 0.25
set boxwidth 0.9
# set style fill pattern border lt -1


# set grid y
set style data histograms
set style histogram rowstacked
set boxwidth 0.9
set style fill solid 0.75 border -1
set xlabel "Queries per second"
set ylabel "Percentage"
# set ytics 10 nomirror
# set yrange [:60]
# set ylabel "Number of Referrals"
# set ytics 10

set termoption enhanced
set style histogram rowstacked title offset 0,-1
set bmargin 5

set yrange [0:100]
set output "ram-bars-stacked.eps"
plot newhistogram "{/*0.8 2}"."\n"."{/*0.8 }", 'qps2-data.csv' using 2:xtic(1) notitle lt 1 lc 1, '' using 3 notitle lt 1 lc 6, \
newhistogram "{/*0.8 8}"."\n"."{/*0.8 }", 'qps8-data.csv' using 2:xtic(1) title 'Kernel space' lt 1 lc 1, '' using 3 title 'User space' lt 1 lc 6, \
newhistogram "{/*0.8 32}"."\n"."{/*0.8 }", 'qps32-data.csv' using 2:xtic(1) notitle lt 1 lc 1, '' using 3 notitle lt 1 lc 6, \
newhistogram "{/*0.8 128}"."\n"."{/*0.8 }", 'qps128-data.csv' using 2:xtic(1) notitle lt 1 lc 1, '' using 3 notitle lt 1 lc 6
