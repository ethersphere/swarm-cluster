#!/bin/bash


echo "Startup is handled by kubernetes secret."

if [ -f "/root/bzzdstartup/script"  ]; then
	cp /root/bzzdstartup/script /startup.sh && chmod +x /startup.sh && /startup.sh
fi
