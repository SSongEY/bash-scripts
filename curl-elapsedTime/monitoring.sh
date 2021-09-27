#!/bin/bash

today=$(date +%y-%m-%d)
log_file=log.${today}

start_time=`echo $(date +%y-%m-%dT%H:%M:%S)`

log_data=$(curl -sS -w "\
status: %{http_code} \
time_connect: %{time_connect} \
time_appconnect: %{time_appconnect} \
time_pretransfer: %{time_pretransfer} \
time_starttransfer: %{time_starttransfer} \
total_time: %{time_total}\n" \
-k -X POST https://test.com \
-H "Content-Type: application/json" \
--data-raw '{"limit": 1,"search_text": "test"}' \
-o /dev/null)

echo ${start_time} ${log_data}  >> ${log_file}
