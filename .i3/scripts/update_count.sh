#!/bin/bash

HELD=0 # set how many packages we're holding
PML=$(pacaur -Sup | wc -l)
touch /tmp/udc
UC=$(( $PML - $HELD - 1))

echo -n $UC

if (( UC > 0 ))
then
		echo "\",\"color\": \"#FFF50D" &
        notify-send -a "Available Updates" -u normal "$(yaourt -Qu)"
        sleep 1 && pacaur -Qu > Documenti/updates
        sleep 2 && terminator -e pacaur -Syyua --noconfirm && i3-msg restart
else
		echo "\",\"color\": \"#909090" &
fi
