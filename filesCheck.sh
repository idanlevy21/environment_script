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
