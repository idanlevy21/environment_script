#!/bin/bash

pathEnv=$(cat /var/tmp/environment)
pathEnvPure="/var/tmp/environment"
echo "Current running environment: $pathEnv"

PS3="Select the desired router's enviornment please: "
select env in "registration.staging.sam.securingsam.io" "registration.prod.bzq.securingsam.com" "agent-gateway.lab.lg.securingsam.com" "crm.digitalsecurity-uat.appdev.io" "crm.prod.lg.securingsam.com" "registration.int.digitalsecurity.telenet.be" "registration.prd.digitalsecurity.telenet.be" "https://agent-gateway.demo.sam.securingsam.io/v3" "agent-gateway.lab.digitalsecurity.telenet.be"
do
        echo "You have chosen $env"
        echo "$env" > "$pathEnvPure"
        echo "Your new environment is set to: $pathEnv"

break
done

#Validate we are inside /var/sam before deleting files
workingDir=$(pwd)
filesDir="/var/sam/"
if [ "$workingDir" != "$filesDir" ]; then
        cd "$filesDir"
        echo "You aren't inside the correct directory, changing to /var/sam"
else
        echo "You are inside the correct directory: $workingDir"
fi

#Files to delete
#.jwt_token .sam_auth mode flag *.log samdb

if [ -f .jwt_token ]; then
        echo ".jwt_token exist, deleting"
        #rm .jwt_token
else
        echo ".jwt_token doesn't exist, ignoring"
fi

if [ -f .sam_auth ]; then
        echo ".sam_auth exist, deleting"
        #rm .sam_auth
else
        echo ".sam_auth doesn't exist, ignoring"
fi

if [ -f mode ]; then
        echo "mode exist, deleting"
        #rm mode
else
        echo "mode doesn't exist, ignoring"
fi

if [ -f flag ]; then
        echo "flag exist, deleting"
        #rm flag
else
        echo "flag doesn't exist, ignoring"
fi

if [ -f samdb ]; then
        echo "samdb exist, deleting"
        #rm samdb
else
        echo "samdb doesn't exist, ignoring"
fi

if [ "ls *.log | wc -l" != "0" ]; then
        echo "*.log exist, deleting"
        #rm *.log
else
        echo "*.log don't exist, ignoring"
fi

mainStatus=$(pgrep -x "main" | wc -l)
agentStatus=$(ps | grep sam | grep -v 'grep' | wc -l)

if [ "$mainStatus" == 1 ]; then
        echo "Agent is up, starting to kill the agent"
        killall sam
        while [ "$agentStatus" != 1 ];do
                agentStatus=$(ps | grep sam | grep -v 'grep' | wc -l)
                echo "Agent still not down"
                sleep 5
         done
else
         echo "Agent is down, please fix it…"
fi

echo "The agent is down now, starting to kill the mini_agent"

miniAgentPID=$(pgrep -x "/var/sam/mini_agent")
miniAgent=$(pgrep -x "/var/sam/mini_agent" | wc -l)

if [ "$miniAgent" == 1 ]; then
        kill -9 $miniAgentPID
        echo "Terminated mini_agent process"
else
       echo "mini_agent is already down, proceeding with starting the agent"
fi

#Hash the PID's
previousHash=""
target=18
/var/sam/sam&

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
                                sleep 1
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
