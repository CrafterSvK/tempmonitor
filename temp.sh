#!/bin/sh
help() {
	echo
	echo "Linux temperture program:"
	echo " -h, --help display this help"
	echo " -b, --bare measure temperture once."
	echo " -l, --loop [quantity] [speed]"
	echo "You can also loop infinitely by setting quantity to 'inf'"
	echo "Example:"
	echo "(./temp.sh --loop 250 10)"
	echo "will measure 250 times with 10 seconds between each measure"
	echo 
	exit 0
}

temp() {
	temp_raw=$(cat /sys/class/thermal/thermal_zone"$1"/temp)
	temp=$(echo "scale = 2; $temp_raw / 1000" | bc)
	echo "$temp°C"
}

show() {
	echo "$(temp 0)", "$(temp 1)", "$(temp 2)"
}

loop() {
	timer="$1"
	until [ "$timer" -lt 1 ]; do
		show	
		timer=$("echo ""$timer" -1"" | bc)
		sleep "$2"
	done
}

## Parsing empty argument
if [ -z "$1" ]; then
	echo "Usage ./temp.sh [[-b, --bare; -h, --help; -t, --loop [quantity] [time between each measurement]]]"
## Parsing "-h" or "--help" argument
elif [ "$1" = -h ] || [ "$1" = --help ]; then
	help
## Parsing "-b" or "--bare" argument
elif [ "$1" = -b ] || [ "$1" = --bare ]; then
	show	
## Parsing loop argument
elif [ "$1" = -l ] || [ "$1" = --loop ]; then
	## If argument $2 is empty loop 10 times with 1 second between each measurement
	if [ -z "$2" ]; then
		loop 10 1
	## Infinitely loop
	elif [ "$2" = inf ]; then
		## If argument $3 is empty display hint
		if [ -z "$3" ]; then
			echo "You need to specify quantity (see --help) "
		else
			while true; do
				show	
				sleep "$3"
			done
		fi
	## If argument $3 is empty display hint
	elif [ -z "$3" ]; then
		echo "You need to specify quantity (see --help) "

	else
		## Loop if $2 is number
		if [ "$("echo $2" | bc)" != 0 ]; then
			## Loop if $3 is a number if not loop with 10 seconds between each measurement
			if [ "$("echo $3" | bc)" != 0 ]; then
				loop "$2" "$3"
			else
				loop "$2" 10
			fi
		fi
	fi
fi

exit 0
