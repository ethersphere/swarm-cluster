#!/bin/bash

# The purpose of this script is to generate secret keys for use with the bzzd-deployments.

mkdir -p bzzd-keys
for i in $( seq 0 34 ); do
	PORT=30399
	let "PORT += $i"

	rm -rf /tmp/BZZ/bzzd-$PORT
	mkdir -p /tmp/BZZ/bzzd-$PORT
#
	echo "generating new key for bzzd-$PORT"
	$GOPATH/src/github.com/ethereum/go-ethereum/geth --datadir=/tmp/BZZ/bzzd-$PORT account new < <( echo && echo ) > /dev/null
	keyfile=/tmp/BZZ/bzzd-$PORT/keystore/UTC*
#	
	echo "Adding key secret to bzzd-keys/bzzd-$PORT-secret.yaml"
	KEYFILE="`echo -n $keyfile`"
	# echo "Keyfile is $KEYFILE"
    ACCOUNT="`echo -n $keyfile | tail -c 40`"
    # echo "Account is $ACCOUNT"
    KEYFILENAME="`echo -n $keyfile | tail -c 77`"
    # echo "Filename is $KEYFILENAME"
	kubectl --namespace 'swarm' create secret generic --from-literal=filename="$KEYFILENAME" --from-file=thekey="$KEYFILE" --from-literal=bzzaccount="$ACCOUNT" --dry-run -o yaml bzzd-key-$PORT >> bzzd-keys/bzzd-$PORT-secret.yaml
    echo "---" >> bzzd-keys/bzzd-$PORT-secret.yaml
    echo && echo
#
done

echo "Configs generated in ./bzzd-keys"
echo "Deploy first time with: kubectl --namespace='swarm' create --recursive -f ./bzzd-keys/"
