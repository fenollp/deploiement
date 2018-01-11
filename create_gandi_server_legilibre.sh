#!/bin/sh

vm=`gandi vm list`
if [ $? = 1 ]; then
	gandi setup
	vm=`gandi vm list`
	if [ $? = 1 ]; then
		exit 1
	fi
fi

arg_sshkey=""
sshkey=`gandi sshkey list`
if [ -n "$sshkey" ]; then
	arg_sshkey="--sshkey `echo $sshkey|grep -m 1 name|awk '{print $3}'`"
fi

gandi vm create --datacenter 'FR-SD5' --cores 2 --memory 4096 --ip-version 4 --size '10G' --image 'Debian 9' --run 'cd /root && wget http://download.seb35.fr/deploy_legilibre.sh && chmod +x deploy_legilibre.sh && ./deploy_legilibre.sh' --login $USER $arg_sshkey --ssh
