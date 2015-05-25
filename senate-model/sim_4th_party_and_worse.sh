if [ $# -lt 2 ]
  then
    echo "Useage: run_simulation_parallel.sh TRIALS_N YEAR"
    exit
fi

N=$1
year=$2
hp="--half-participation"
#hp=""

echo "Starting NVB Simulation, $N trials per data-point"
echo ""
echo "Using as half participation flag: '$halfpartic'"

function runmain {
    file=$1
    pc=$2
    state=$3
    year=$4
    fpr=0.01
    minpref=6.1
    echo "Started: $state-$pc"
    # min-pref 6.1, halfpartic true, fpr 0.01
    python3 -m dg main.dg --summary --loop $N --pc-yes $pc --first-pref-ratio $fpr --nvb $hp --min-preference $minpref "$year/$state-gvts.csv" "$year/$state-first-prefs.csv" >> $file
    echo `cat $file | grep NVB | wc -l` ",$N,$state,$pc%" >> all.results
    echo "Finished: $state-$pc"
}

rm all.results &>/dev/null

for state in NSW VIC TAS WA SA QLD
  do for pc in 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95
  #do for pc in 5 15 25 35 45 55 65 75 85 95
    do
    file="$year/results-sim-4th-party-and-worse-$state-$pc.txt"
    echo $file
    rm $file &>/dev/null
    runmain $file $pc $state $year &
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
