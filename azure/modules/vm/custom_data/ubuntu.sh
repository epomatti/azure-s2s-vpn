#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt update && apt upgrade -y

### Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

### NGINX
apt install -y nginx traceroute
