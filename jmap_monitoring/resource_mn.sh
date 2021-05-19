#!/bin/bash

LOG=log_res_mn

while [ true ]
do

	echo `echo \[;date;echo \]` >> $LOG
	echo `echo netstat 8000 cnt \[;netstat -na | grep 8000 | wc -l;echo \];` >> $LOG
	echo `echo netstat 3306 cnt \[;netstat -na | grep 3306 | wc -l;echo \];` >> $LOG
	ps -eo pid,rss,size,vsize,pmem,pcpu,time,cmd --sort -rss | grep NAMU | head -n 1 >> $LOG
	#ps -eo pid,rss,size,vsize,pmem,pcpu,time,cmd --sort -rss | head -n 5 >> $LOG
	echo ------------------------------------------------------------------------ >> $LOG
	sleep 1;
done;
