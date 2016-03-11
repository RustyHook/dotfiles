#!/bin/sh

# ObliviousGmn, June 2015
# https://github.com/ObliviousGmn
# Panel for Lemonbar ..

. $HOME/.i3/lemonbar/bar_config

 ws(){ # Current Workspace .. 
  ws=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
	case ${ws} in
		0) echo " ";;
		1) echo " ";;
		2) echo " ";;
		3) echo " ";;
		*) echo " ";;
	esac
}

 menu(){ # Useless for now ..
	echo "%{B$BBLUE}%{F$BG} GMN  %{B-}%{F-}"
}

 temp(){ # CPUs temp ..
  temp=`sensors | awk '/Core 0/ {print +$3}'`
	echo "%{F$BBLUE}  %{F-} ${temp}°"
}
	
 fan(){ # Fan speeds ..
  fan=`sensors | awk '/fan1/ {print $2,$3}'`
	echo "%{F$BBLUE}  %{F-} ${fan}"
}

 clock(){ # Clock, obv ..
  clock=`date "+%b %d %Y %I:%M"`
	echo "%{F$BBLUE}  %{F-} ${clock}"
}

 vol(){ # Volume, Sets to Headset when switched ..
  switch=`amixer get Master | awk '/Mono:/ {print $6}'`
  vol=`amixer get Master | awk '/Mono:/ {print $4}' | tr -d '[]%,'`
  hsvol=`amixer get PCM | awk '/Mono:/ {print $4}' | tr -d '[]%,'`

  if [ "$switch" = "[on]" ]; then
	echo "%{F$BBLUE}  %{F-} ${vol}"
  elif [ "$switch" = "[off]" ]; then
	echo "%{F$RED}  %{F-} MUTE"
  else
	echo "%{F$BBLUE}  %{F-} ${hsvol}"
  fi
}

 mus(){ # Current song ..
  mus=`mpc current -f %title%`

  if [[ $mus ]]; then
 	echo "%{F$BBLUE}  %{F-} ${mus}"
  fi
}

 last(){ # Weechat, Last highlight ..
  last=`(tail -n1) <$HOME/Gmnbox/Panel/Weelog`

  if [[ $last ]]; then
  	echo "%{A:cat /dev/null > $HOME/Gmnbox/Panel/Weelog:}${last}%{A}"
  fi
}

 net(){ # Connected or nah? ..
  ping=`ping 8.8.8.8 -c 1 | awk '/rtt/ {printf("%d\n",$4 + 0.5)}'`
  test -n "${ping}" && echo "%{F$BBLUE}  %{F-} ${ping}ms" || echo "%{F$RED}  %{F-} No Connection"
}

while :; do

 # Run ping in intervals ..
 [[ loops -eq 15 ]] && loops=0
 [[ loops -eq 0 ]] && ping=$(net)
 loops=$(( loops + 1 ))

	echo "  $(ws) $(menu) $(vol) $(last) %{c}$(mus) %{r}$(temp) $(fan) $ping $(clock)  "
         sleep 0.5	
		 
 done | lemonbar -g ${PW}x${PH}+${PO}+${PO} -f "$FONT1" -f "$ICON2" -B "$BG" -F "$BYELLOW" -d -p | \
	while read line; do eval "$line"; done &
