#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y

### AWS CLI ###
curl "https://awscli.amazonaws.com/awscli-exe-linux-$unameMachine.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
