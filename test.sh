#!/bin/bash

#Check Sam's PID's
#ps |grep sam | grep -v 'grep' |awk '{print $1}'

#Hash the PID's
previousHash=""
target=30

#Shows anything besides S status
agentExists=$(ps |grep sam | grep -v 'grep' |grep -v ' S '| wc -l)

while true; do
	currentHash=$(ps |grep sam | grep -v 'grep' |awk '{print $1}' | md5sum | awk '{print $1}' )
	if [ "$previousHash" == "$currentHash" ]; then
		echo "Found same processes, making sure they are stable..."
                i=1
                while [ "$i" -lt $target ]; do
			previousHash="$currentHash"
			currentHash=$(ps |grep sam | grep -v 'grep' |awk '{print $1}' | md5sum | awk '{print $1}' )
			if [ "$previousHash" == "$currentHash" ]; then
				((i++))
				echo "stable ($i/$target).."
                                sleep 6
			else
				echo "Not stable! retrying..."
				break
                        fi
                done
		
		if [ "$i" -eq $target ]; then
			echo "The Agent is up and running"
			break
		fi
	else
		echo "Not stable! retrying..."
	fi

	previousHash="$currentHash"
done
