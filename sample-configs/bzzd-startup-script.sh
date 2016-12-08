#!/bin/bash

# This is the bzzd startup script. It should be made a kubernetes secret with
#
# 	kubectl --namespace "swarm" create secret generic --from-file=script=./bzzd-startup-script.sh bzzd-startup-script
#
#	or create a .yaml first with:
#
#	kubectl --namespace "swarm" create secret generic --from-file=script=./bzzd-startup-script.sh --dry-run bzzd-startup-script -o yaml > bzzd-startup-script.yaml
#
# The way this works is as follows:
# This secret will be mounted in our bzzd containers at 
#
#	/root/bzzdstartup 
#
# and the docker container is set to execute
#
#	/root/bzzdstartup/script at startup
#
# When you update this script you must update the kubernetes secret.
#
# Why are we doing it this way?
#
# During bzzd testing we have to change this script often.
# It is much easier to update a secret than to rebuild a docker container.
#


if [ "$DATADIR" == "" ]; then export DATADIR="/root/.ethereum/$BZZ_PORT"; fi
echo "Datadir is $DATADIR"

#import the key from the mounted kubernetes secret
if [ -f "$DATADIR/keystore/`cat /root/keyimport/filename`" ]; then
	echo "Key already exists. No need to generate from secret"
else
	echo "Preparing the keyfile from kubernetes-secret"
	mkdir -p $DATADIR/keystore
    cat /root/keyimport/thekey >> "$DATADIR/keystore/`cat /root/keyimport/filename`"
fi

echo "BZZ account is $BZZACCOUNT"

echo "Starting bzzd..."

/bzzd   --ethapi=$ETHAPI \
        --bzzaccount=$BZZACCOUNT \
        --ipcpath "/bzzd.ipc" \
        --port=$BZZ_PORT \
        --bzzport=$BZZ_HTTP_PORT \
        --datadir $DATADIR \
        --nat=extip:13.74.157.139 \
        < <(echo && echo) 

echo "end of startup script"

