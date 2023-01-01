#!/bin/bash

mainStatus=$(pgrep -x "main" | wc -l)

if [ "$mainStatus" == 1 ]; then
        echo "Agent is up, starting to kill the agent"
        killall sam
        while [ "$agentStatus" != 1 ];do
                agentStatus=$(ps | grep sam | grep -v 'grep' | wc -l)
                echo "Agent still not down"
                sleep 5
         break
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
