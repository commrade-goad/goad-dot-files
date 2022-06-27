#!/bin/bash

COUNT=$(dunstctl count waiting)
ENABLED=
DISABLED=
if [ $COUNT != 0 ];
	then DISABLED=" $COUNT";
fi
if dunstctl is-paused | grep -q "false" ;
	then
		printf '{"text": "%s", "tooltip": "Notification : Enabled", "class": "enabled"}' "$ENABLED";
	else
		printf '{"text": "%s", "tooltip": "Notification : Do Not Disturb", "class": "disabled"}' "$DISABLED";
fi
