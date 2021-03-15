#!/bin/bash

PROD_PATH=/home/hkmc/v2g
LOG_PATH=$PROD_PATH/logs
OPERATION_LOG=$LOG_PATH/operation.log
SERVER_LOG=$LOG_PATH/server.log

LOGTIME=`date`
PORT=15118

echo "${LOGTIME}: AutoCrypt V2G Server Start" >> ${OPERATION_LOG}

nohup java -Xmx1024m -jar -Duser.timezone=Asia/Seoul ./AutoCrypt-V2G-3.1.179-SNAPSHOT_SUB.jar \
	--server.port=15118 --spring.profiles.active=hmc_prod_sub \
	>> ${SERVER_LOG} &

echo $! > ${PROD_PATH}/pid
PID=`cat ${PROD_PATH}/pid`
echo "${LOGTIME}: AutoCrypt V2G Server Start(${PID}) Success" >> ${OPERATION_LOG}
