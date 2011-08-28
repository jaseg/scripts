#!/bin/bash

if [ $(</sys/class/power_supply/AC/online) -eq 1 ]
then	echo "AC"
fi
charge=$(bc<<<"scale=3;$(</sys/class/power_supply/BAT0/charge_now)/$(</sys/class/power_supply/BAT0/charge_full)")
if [[ $charge =~ 1\. ]]
then charge=1
fi
status=$(</sys/class/power_supply/BAT0/status)
echo $status
if [ "$status" != "Full" ]
then
	echo $charge
	if [ "$status" != "Charging" ]
	then
		if [ ${charge#.} -lt 100 ]
		then
			notify-send -t 1000 -u critical "Power Management" "Battery at $charge"
			espeak -a 400 "Battery warning! Please connect to AC adaptor."
		elif [ ${charge#.} -lt 200 ]
		then
			notify-send -t 1000 "Power Management" "Battery at $charge"
		fi
	fi
fi
