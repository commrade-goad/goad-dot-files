#!/bin/bash

startup () {
	pidof -o %PPID -x $0 >/dev/null && echo "ERROR: Script $0 already running" && exit 1
}

check () {
	BATTSTATUS=$(cat /sys/class/power_supply/BAT1/status)
	BATTCAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
}

main () {
	while true
	do
		check
		echo "Battery status : $BATTSTATUS"
		echo "Battery percentage : $BATTCAPACITY"
		if [ $BATTSTATUS != "Charging" ]
		then
			if [ $BATTSTATUS != "Full" ]
			then
				if [[ $BATTCAPACITY > 75 ]]
				then
					echo "Enough... (sleep for 5m)"
					sleep 5m
				elif [[ $BATTCAPACITY < 30 ]]
				then
					echo "Low... (will notify again after 2m)"
					dunstify -u 2 "Your Battery is lower than 30%. Please plug in the charger."
					sleep 120
				fi
			else
				echo "Full or Unknown.. (sleep for 5m)"
				sleep 5m
			fi
		elif [ $BATTSTATUS == "Charging" ]
		then
			echo "Charging... (sleep for 5m)"
			sleep 5m
		fi
		sleep 3
	done
}

startup
main
