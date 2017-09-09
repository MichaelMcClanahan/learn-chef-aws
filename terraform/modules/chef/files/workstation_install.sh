#!/bin/bash

# Log to screen
set -x

# Elevate priviledges, retaining the environment.
sudo -E su

# Install packages and update yum
yum install git wget -y
yum update -y

# Ensure server hostname matches public hostname
echo $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) | xargs sudo hostname

# Install Chef DK
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.0.28
