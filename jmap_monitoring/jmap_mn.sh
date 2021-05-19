#!/bin/bash

while [ true ]
do
	PID=`sudo jps -v | grep "\-Xmx2048m" | awk '{print $1}'`
	echo `echo \[;date;echo \]` >> log_mn_jvm
	sudo jmap -histo:live $PID | head -n 10 >> log_mn_jvm
	echo ------------------------------------------------------- >> log_mn_jvm
	sleep 10;
done;

