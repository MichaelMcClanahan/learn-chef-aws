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

# # Install Chef DK
# curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.0.28

# # Use Chef Ruby
# echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile

# # Make Chef Repo
# mkdir ~/chef-repo/ ~/chef-repo/.chef/

# cat << 'EOF' > ~/chef-repo/.chef/knife.rb
# current_dir = File.dirname(__FILE__)
# log_level                 :info
# log_location              STDOUT
# node_name                 "chefadmin"
# client_key                "#{current_dir}/chefadmin.pem"
# chef_server_url           "https://"${aws_instance.chef-server.public_dns}"/organizations/learnchefaws"
# cookbook_path             ["#{current_dir}/../cookbooks"]
# EOF
