#!/bin/bash

# Log to screen
set -x

# Elevate priviledges, retaining the environment.
sudo -E su

# # Install packages and update yum
# yum install git wget -y
# yum update -y

# # # Ensure server hostname matches public hostname
# # echo $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) | xargs sudo hostname
