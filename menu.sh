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
