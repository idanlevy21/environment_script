#!/bin/bash

#Check Sam's PID's
#ps |grep sam | grep -v 'grep' |awk '{print $1}'

#Hash the PID's
hash=$(ps |grep sam | grep -v 'grep' |awk '{print $1}' | md5sum | cut -d "-" -f1)

#Shows anything besides S status
anomaly=$(ps |grep sam | grep -v 'grep' |grep -v ' S '|awk '{print $1}' | wc -l)

while [ "$hash" == "$hash" ]
do
        if [ "$anomaly" -ge "1" ]; then
                echo "$anomaly"
        else
                SAM="SAM is up"
        fi

                i=1
                while [ "$i" -lt 30 ]
                do
                        if [ "$SAM" == "$SAM" ]; then
                                sleep 6
                        fi
                ((i++))
                echo "The agent is being loaded"
                done
break
done
echo "SAM is up and running"
