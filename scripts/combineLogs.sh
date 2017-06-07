#!/bin/bash

for oldDir in logs/500sessionsOLD/network1/*/ ; do

  ip_address=`basename $oldDir`
  newDir=logs/honssh500/sessions/network1/$ip_address

  if [ ! -d $newDir ]; then
    mkdir $newDir
  fi

  mv $oldDir/* $newDir

done
