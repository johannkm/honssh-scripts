#!/bin/bash

function run {

  outFile=data/$1.csv
  > $outFile

  for d in logs/honssh$1/sessions/network1/*/ ; do

    ip_address=`basename $d`

    checkIfOutside $ip_address
    if [ $discard -eq 1 ]; then
      continue
    fi

    visits=`ls $d/*.log | wc -l | sed -e 's/^[ ]*//'`

    timeArr=()
    commandArr=()

    for logFile in $d/*.log ; do

      timeIn=`head -1 $logFile | cut -d " " -f1 | cut -d "_" -f2`
      timeOut=`tail -1 $logFile | cut -d " " -f1 | cut -d "_" -f2`

      timeInSecs=$(( $((10#${timeIn:0:2}))*3600 + $((10#${timeIn:2:2}))*60 + $((10#${timeIn:4:2})) ))
      timeOutSecs=$(( $((10#${timeOut:0:2}))*3600 + $((10#${timeOut:2:2}))*60 + $((10#${timeOut:4:2})) ))

      restartTime $timeInSecs $timeOutSecs

      if [ $discard -eq 1 ]; then
        continue
      fi

      timeArr+=($(( timeOutSecs - timeInSecs )))
      commandArr+=($(grep "Command Executed:" $logFile | wc -l))

    done

    sessions=${#timeArr[@]}

    if [ $sessions -gt 0 ]; then

      timeStr=$(join_by , "${timeArr[@]}")
      commandStr=$(join_by , "${commandArr[@]}")

      echo "$d,$ip_address,$visits,$sessions,$timeStr,$commandStr" >> $outFile
    fi

  done
}

function join_by { local IFS="$1"; shift; echo "$*"; }

function restartTime {

  if [ $(( $2 - $1 )) -gt 1200 ]; then # longer than 20 min
    discard=1
  elif [ $1 -le 21600 ] && [ $2 -ge 21600 ]; then # 6am
    discard=1
  elif [ $1 -le 43200 ] && [ $2 -ge 43200 ]; then # 12pm
    discard=1
  elif [ $1 -le 64800 ] && [ $2 -ge 64800 ]; then # 6pm
    discard=1
  elif [ $1 -gt $2 ]; then # 12am
    discard=1
  else
    discard=0
  fi

}

function checkIfOutside {

  discard=0

  if [ `echo $1 | cut -d'.' -f1` = "10" ]; then # local ip
    discard=1
  fi

  for ip in "${testingIps[@]}" ; do
    if [ $ip = $1 ]; then
      discard=1
    fi
  done
}

testingIps=("129.2.181.54" "108.51.68.182" "69.251.14.6" "69.251.14.6" "71.244.48.92" "129.2.181.81" "108.51.68.182" "129.2.181.81")

run 300
run 400
run 500
run 600

> data/all.csv
cat data/300.csv >> data/all.csv
cat data/400.csv >> data/all.csv
cat data/500.csv >> data/all.csv
cat data/600.csv >> data/all.csv
