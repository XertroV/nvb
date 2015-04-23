N=1000

function runmain {
    file=$1
    pc=$2
    state=$3
    python -m dg main.dg --summary --loop $N --pc-yes $pc --nvb --half-participation $state-gvts.csv $state-first-prefs.csv >> $file
    echo `cat $file | grep NVB | wc -l` ",$N,$state,$pc%" >> all.results
    echo `cat $file | grep NVB | wc -l` ",$N,$state,$pc%"
}

for pc in 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95
  do for state in NSW VIC TAS WA SA QLD 
    do
    file="results$state$pc"
    rm $file
    runmain $file $pc $state &
  done
done


