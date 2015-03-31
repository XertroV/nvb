#!/bin/bash

function push_to_file {
  echo $1 >> $(echo $1 | cut -d ',' -f 1)-gvts.csv
}

cat SenateGroupVotingTicketsDownload-17496.csv | tail -n +3 > just_prefs.csv

while read l; do
  push_to_file "$l"
done < just_prefs.csv

