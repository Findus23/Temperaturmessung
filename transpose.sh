#!/bin/bash
#(c) Peter Reutemann: http://www.cs.waikato.ac.nz/~fracpete/programming/csv2gnuplot/
echo "Zeit LOAD Temperatur" > temp
cat daten_gnuplot.txt >> temp
cat temp | exec awk '
   NR == 1 {
          n = NF
           for (i = 1; i <= NF; i++)
                   row[i] = $i
           next
   }
   {
           if (NF > n)
                   n = NF
           for (i = 1; i <= NF; i++)
                   row[i] = row[i] " " $i
   }
   END {
           for (i = 1; i <= n; i++)
                   print row[i]
   }' > daten_transformiert.txt
rm temp
