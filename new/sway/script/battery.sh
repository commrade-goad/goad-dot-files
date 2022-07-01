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
		if [ $BATTSTATUS == "Charging" ]
		then
			echo "Charging... (sleep for 5m)"
			sleep 5m
		elif [ $BATTSTATUS == "Unknown" ]
		then
			echo "Unknown... (sleep for 5m)"
			sleep 5m
		elif [ $BATTSTATUS == "Full" ]
		then
			echo "Full... (sleep for 5m)"
			sleep 5m
		else
			if [[ $BATTCAPACITY > 60 ]]
			then
				echo "$BATTCAPACITY > 60 (sleep for 5m)"
				sleep 5m
			elif [[ $BATTCAPACITY < 30 ]]
			then
				echo "Low... (will notify again after 2m)"
				dunstify -u 2 "$BATTCAPACITY% Battery remaining, please plug in the charger." & mpv "$HOME/Downloads/batt-reminder.mp3" --no-video --volume=75
				sleep 120
			fi
		fi
		sleep 3
	done
}

startup
main
