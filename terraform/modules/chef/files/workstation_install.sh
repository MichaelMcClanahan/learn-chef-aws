#!/bin/bash

# Log to screen
set -x

# Install packages and update yum
sudo yum install git wget -y
sudo yum update -y

# Ensure server hostname matches public hostname
echo $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) | xargs sudo hostname

# Install Chef DK
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.0.28

# Use Chef Ruby
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile

# Make Chef Repo
mkdir /home/ec2-user/chef-repo/ /home/ec2-user/chef-repo/.chef/ /home/ec2-user/chef-repo/cookbooks/

cat << 'EOF' > /home/ec2-user/chef-repo/.chef/knife.rb
current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
node_name                 "chefadmin"
client_key                "#{current_dir}/chefadmin.pem"
chef_server_url           "https://${chef_server}/organizations/learnchefaws"
cookbook_path             ["#{current_dir}/../cookbooks"]
EOF
