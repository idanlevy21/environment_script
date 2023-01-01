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
