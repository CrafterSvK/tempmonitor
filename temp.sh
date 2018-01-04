#!/bin/bash
#Based on Raspberry Pi temp program from 2016 (See legacy folder)
function help {
	echo
	echo "Linux temperture program: "
	echo "-h, --help display this help"
	echo "-b, --bare measure temperture once."
	echo "-l, --loop [quantity] [speed]"
	echo "You can also loop infinitely by setting quantity to 'inf'"
	echo "Example: "
	echo "(./temp.sh --loop 250 10)"
	echo "will measure 250 times with 10 seconds between each measure"
	echo ""
	exit
}

function temp0 {
	temp0_raw=$(cat /sys/class/thermal/thermal_zone0/temp)
	temp0_1=$(($temp0_raw / 1000))
	temp0_2=$(($temp0_raw / 100))
	temp0_M=$(($temp0_2 % $temp0_1))
	temp0=""$temp0_1"."$temp0_M"°C"
}

function temp1 {
	temp1_raw=$(cat /sys/class/thermal/thermal_zone1/temp)
	temp1_1=$(($temp1_raw / 1000))
	temp1_2=$(($temp1_raw / 100))
	temp1_M=$(($temp1_2 % $temp1_1))
	temp1=""$temp1_1"."$temp1_M"°C"
}

function temp2 {
    temp2_raw=$(cat /sys/class/thermal/thermal_zone2/temp)
    temp2_1=$(($temp2_raw / 1000))
    temp2_2=$(($temp2_raw / 100))
    temp2_M=$(($temp2_2 % $temp2_1))
    temp2=""$temp2_1"."$temp2_M"°C"
}

function loop {
	timer=$1
	until [[ $timer -lt 1 ]]; do
		temp0; temp1; temp2
	    echo $temp0", "$temp1", "$temp2
		sleep $2
		let timer-=1
	done
	echo "loop has ended"
}

## Parsing empty argument
if [[ -z $1 ]]; then
	echo "Usage ./temp.sh [[-b, --bare; -h, --help; -t, --loop [quantity] [time between each measurement]]]"
## Parsing "-h" or "--help" argument
elif [[ $1 = -h ]] || [[ $1 = --help ]]; then
	help
## Parsing "-b" or "--bare" argument
elif [[ $1 = -b ]] || [[ $1 = --bare ]]; then
	temp0; temp1; temp2
	echo $temp0", "$temp1", "$temp2
## Parsing loop argument
elif [[ $1 = -l ]] || [[ $1 = --loop ]]; then
	## If argument $2 is empty loop 10 times with 1 second between each measurement
	if [[ -z $2 ]]; then
		loop 10 1
	## Infinitely loop
	elif [[ $2 = inf ]]; then
		## If argument $3 is empty display hint
		if [[ -z $3 ]]; then
			echo "You need to specify quantity (see --help) "
		else
			while true; do
				temp0; temp1; temp2
				echo $temp0", "$temp1", "$temp2
				sleep $3
			done
		fi
	## If argument $3 is empty display hint
	elif [[ -z $3 ]]; then
		echo "You need to specify quantity (see --help) "

	else
		## Loop if $2 is number
		if [[ $(($2)) = $2 ]]; then
			## Loop if $3 is a number if not loop with 10 seconds between each measurement
			if [[ $(($3)) = $3 ]]; then
				loop $2 $3
			else
				loop $2 10
			fi
		fi
	fi
fi

