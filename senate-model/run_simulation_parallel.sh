if [ $# -eq 0 ]
  then
    echo "Useage: run_simulation_parallel.sh TRIALS_N"
    exit
fi

N=$1

echo "Starting NVB Simulation, $N trials per data-point"
echo ""

function runmain {
    file=$1
    pc=$2
    state=$3
    echo "Started: $state-$pc"
    python3 -m dg main.dg --summary --loop $N --pc-yes $pc --nvb --half-participation $state-gvts.csv $state-first-prefs.csv >> $file
    echo `cat $file | grep NVB | wc -l` ",$N,$state,$pc%" >> all.results
    echo "Finished: $state-$pc"
}

rm all.results &>/dev/null

for state in NSW VIC TAS WA SA QLD
  do for pc in 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95
    do
    file="results$state$pc"
    rm $file &>/dev/null
    runmain $file $pc $state &
  done
done

echo ""
echo "[[This takes a long time if you've opted to run many trials]]"
echo ""

wait

echo "COMPLETE"

echo "RESULTS:"
echo "========================="
echo ""

cat all.results | python3 format_results.py
