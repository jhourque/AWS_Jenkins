#!/bin/bash

# Check env vars

if [ -z "$AWS_ACCESS_KEY_ID" ]
then
	echo "enter AWS_ACCESS_KEY_ID:"
	read AWS_ACCESS_KEY_ID
fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]
then
	echo "enter AWS_SECRET_ACCESS_KEY:"
	read AWS_SECRET_ACCESS_KEY
fi
if [ -z "$AWS_DEFAULT_REGION" ]
then
	echo "enter AWS_DEFAULT_REGION:"
	read AWS_DEFAULT_REGION
fi
if [ -z "$VPC_ID" ]
then
	echo "enter VPC_ID:"
	read VPC_ID
fi
if [ -z "$SUBNET_ID" ]
then
	echo "enter SUBNET_ID:"
	read SUBNET_ID
fi

echo Give Jenkins admin password:
read PASSWORD

if [ ! -f ~/.ssh/id_rsa.jenkins ]
then
        ssh-keygen -t rsa -f ~/.ssh/id_rsa.jenkins -N ""
fi
SSH_PUB=$(cat ~/.ssh/id_rsa.jenkins.pub)

# Inject ssh public key in groovy script
cat files/init.groovy.skel | sed "s#<SSH_PUB>#$SSH_PUB#" | sed "s#<PASSWORD>#$PASSWORD#"> files/init.groovy

# Run packer
packer build ami_jenkins.json

