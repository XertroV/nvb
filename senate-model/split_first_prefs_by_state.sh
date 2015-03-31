#!/bin/bash

function push_to_file {
  echo $1 >> $(echo $1 | cut -d ',' -f 1)-first-prefs.csv
}

cat SenateFirstPrefsByStateByVoteTypeDownload-17496.csv | tail -n +3 | grep 'Ticket Votes' > just_tickets.csv

while read l; do
  push_to_file "$l"
done < just_tickets.csv

