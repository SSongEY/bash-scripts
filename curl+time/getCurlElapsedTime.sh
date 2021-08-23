TODAY=$(date +%y-%m-%d)
api_url=https://localhost/api/permissions
session_id=d2ce8f7339aa4427805018a0f2654b55
log_file=permissionLog.${TODAY}

while [ true ]
do
   STIME=`echo $(date +%y-%m-%dT%H:%M:%S)`
   DURATION=$(time(curl -sS -w '%{http_code}\n' -k -X GET ${api_url} -H "bs-session-id: ${session_id}" -o /dev/null) 2>&1)
   DURATION=$(echo ${DURATION} | awk '{print $1, $3}')

   echo ${STIME} ${DURATION} >> ${log_file}

   sleep 10;
done;
