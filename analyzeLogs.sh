#!/bin/bash

function run {

  outFile=data/$1.csv
  echo "path,ip,visits,commands,time" > $outFile

  for d in logs/honssh$1/sessions/network1/*/ ; do

    ip_address=`basename $d`
    visits=`ls $d/*.log | wc -l | sed -e 's/^[ ]*//'`

    for logFile in $d/*.log ; do

      timeIn=`head -1 $logFile | cut -d " " -f1 | cut -d "_" -f2`
      timeOut=`tail -1 $logFile | cut -d " " -f1 | cut -d "_" -f2`

      timeInSecs=$(( $((10#${timeIn:0:2}))*3600 + $((10#${timeIn:2:2}))*60 + $((10#${timeIn:4:2})) ))
      timeOutSecs=$(( $((10#${timeOut:0:2}))*3600 + $((10#${timeOut:2:2}))*60 + $((10#${timeOut:4:2})) ))

      restartTime $timeInSecs $timeOutSecs

      if [ $discard -eq 1 ]; then
        echo $timeIn $timeOut $d
        continue
      fi

      time=$(( timeOutSecs - timeInSecs ))

    done

    echo "$d,$ip_address,$visits" >> $outFile

  done
}

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

run 300
run 400
run 500
run 600
