#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y

apt install -y traceroute nginx unzip

### AWS CLI ###
unameMachine=$(uname -m)

curl "https://awscli.amazonaws.com/awscli-exe-linux-$unameMachine.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
