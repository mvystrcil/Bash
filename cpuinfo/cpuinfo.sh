#!/bin/bash

CPU=0
if [[ -n "$1" ]]
then
	CPU="$1"
fi

CPUINFO=/sys/devices/system/cpu/cpu$CPU
CPUFREQ=/cpufreq
INFO="$CPUINFO"/"$CPUFREQ"

if [ ! -x "$CPUINFO" ]
then
	echo "Cannot read info for cpu $1"
	exit -1
fi

#while true
#do
	if [[ $EUID -eq 0 ]]
	then
		echo "Current frequency:  " $(cat $INFO/cpuinfo_cur_freq)
	fi

	echo "Scaling governon:   " $(cat $INFO/scaling_governor)
	echo "Frequency in range: " $(cat $INFO/scaling_min_freq) " - " $(cat $INFO/scaling_max_freq)
	echo "Related cpus:       " $(cat $INFO/related_cpus)

	sleep 1
#done
