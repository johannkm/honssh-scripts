#!/bin/bash

ips=()

function run {
    for d in honssh$1/sessions/network1/*/ ; do
	curIp=`basename $d`
	add=true
        for ip in $ips ; do
	    if [ "$ip" == "$curIp"  ]; then
		add=false
	    fi
	done
	if [ "$add" = "true" ]; then
	    ips+=($curIp)
	else
	    echo "$curIp rejected"
	fi
    done

}

run 300
run 400
run 500
run 600
echo ${#ips[@]}
