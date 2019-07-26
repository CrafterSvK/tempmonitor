#!/bin/bash
#Created by Jakub Janek v1 02:57 05.07.2016...

cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0 / 1000))
cpuTemp2=$(($cpuTemp0 / 100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))
gpuTempN=$(/opt/vc/bin/vcgencmd measure_temp)
gpuTemp=${gpuTempN::-2}
date=$(date +"%d.%m.%Y %T")

if [[ $1 = -h ]] || [[ $1 = -help ]]; then
   echo ""
   echo "Raspberry pi temperture program: "
   echo "Program without any arguments will display message with: "
   echo "CPU temp, GPU temp and will save it to file..."
   echo ""
   echo "-bare or -b to run temperture test without saving to file..."
   echo ""
   echo "-delete or -clear or -c: will remove file with measurements..."
   echo ""
   echo "-loop [time] [quantity] or -l [time] [quantity]: will loop in seconds..."
   echo "Example 1: '-loop 2' will loop every 2 seconds, 10 times..."
   echo "Example 2: '-loop 10 25' will loop every 10 seconds, 25 times...'"
   echo ""
   exit
fi

if [[ $1 = -loop ]] || [[ $1 = -l ]]; then
   if [[ $(($2)) = $2 ]]; then
      echo "Loop: every "$2" seconds on "$date
      echo "Loop: every "$2" seconds on "$date >> measurements.txt
      if [[ $(($3)) = $3 ]]; then
         timer=$3
         count=1
         until [[ $timer -lt 1 ]]; do
            echo "Measurement: "$count
            echo CPU temp"="$cpuTemp1"."$cpuTempM"°C"
            echo GPU $gpuTemp"°C"
            echo ""

            sleep $2

            echo $count": " >> measurements.txt
            echo CPU temp"="$cpuTemp1"."$cpuTempM"°C" >> measurements.txt
            echo GPU $gpuTemp"°C" >> measurements.txt
            echo "" >> measurements.txt
            let count+=1
            let timer-=1
         done
         echo "Loop has ended..."
         echo "End of the loop..." >> measurements.txt
         echo ""
      else
         timer=10
         count=1
         until [[ $timer -lt 1 ]]; do
            echo "Measurement: "$count
            echo CPU temp"="$cpuTemp1"."$cpuTempM"°C"
            echo GPU $gpuTemp"°C"
            echo ""

            sleep $2

            echo $count": " >> measurements.txt
            echo CPU temp"="$cpuTemp1"."$cpuTempM"°C" >> measurements.txt
            echo GPU $gpuTemp"°C" >> measurements.txt
            echo "" >> measurements.txt
            let count+=1
            let timer-=1
         done
         echo "Loop has ended..."
         echo "End of the loop..." >> measurements.txt
         echo ""
      fi
   else
      echo "Error: not enough arguments or wrong arguments... "
      echo "Use -help..."
      exit
   fi
else
if [[ $1 = -bare ]] || [[ $1 = -b ]]; then
   echo CPU temp"="$cpuTemp1"."$cpuTempM"°C"
   echo GPU $gpuTemp"°C"
   exit
fi

if [[ $1 = -clear ]] || [[ $1 = -delete ]] || [[ $1 = -c ]]; then
   if [ ! -f measurements.txt ]; then
      echo "Measurements were already removed or they weren't created at all..."
   else
      rm measurements.txt
      echo "Measurements removed..."
   fi
else
   echo CPU temp"="$cpuTemp1"."$cpuTempM"°C"
   echo GPU $gpuTemp"°C"

   echo Date"="$date >> measurements.txt
   echo CPU temp"="$cpuTemp1"."$cpuTempM"°C" >> measurements.txt
   echo GPU $gpuTemp"°C" >> measurements.txt
   echo "" >> measurements.txt

   echo "Measurement was successfully saved with the date: "$date
fi
fi
