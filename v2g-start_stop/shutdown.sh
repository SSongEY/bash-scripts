#!/bin/bash
PROD_PATH=/home/hkmc/v2g
LOG_PATH=$PROD_PATH/logs
OPERATION_LOG=$LOG_PATH/operation.log

LOGTIME=`date`

PID=`cat $PROD_PATH/pid`
echo "$LOGTIME: AutoCrypt V2G Server Shutdown" >> $OPERATION_LOG
kill -9 $PID
echo "$LOGTIME: AutoCrypt V2G Server Shutdown($PID) Success" >> $OPERATION_LOG