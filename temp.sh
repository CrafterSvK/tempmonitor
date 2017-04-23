#!/bin/bash
function help {
	echo
	echo "Linux temperture program: "
	echo "no commands available today"
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

if [[ $1 = -h ]] || [[ $1 = --help ]]; then
	help
elif [[ $1 = -b ]] || [[ $1 = --bare ]]; then
	temp0; temp1
	echo $temp0
	echo $temp1
fi

