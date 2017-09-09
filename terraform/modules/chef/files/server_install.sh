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

# Create staging directories
if [ ! -d /drop ]; then
  mkdir /drop
fi
if [ ! -d /downloads ]; then
  mkdir /downloads
fi

# Download the Chef server package
if [ ! -f /downloads/chef-server-core-12.16.2-1.el7.x86_64.rpm ]; then
  echo "Downloading the Chef server package..."
  wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.16.2/el/7/chef-server-core-12.16.2-1.el7.x86_64.rpm
fi

# Install Chef server
if [ ! $(which chef-server-ctl) ]; then
  echo "Installing Chef server..."
  rpm -Uvh /downloads/chef-server-core-12.16.2-1.el7.x86_64.rpm
  chef-server-ctl reconfigure

  echo "Waiting for services..."
  until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
  while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

  echo "Creating initial user and organization..."
  chef-server-ctl user-create chefadmin Chef Admin admin@4thcoffee.com insecurepassword --filename /drop/chefadmin.pem
  chef-server-ctl org-create 4thcoffee "Fourth Coffee, Inc." --association_user chefadmin --filename 4thcoffee-validator.pem

  # echo "Installing Management Console..."
  # chef-server-ctl install chef-manage
  # chef-server-ctl reconfigure
  # chef-manage-ctl reconfigure
fi
