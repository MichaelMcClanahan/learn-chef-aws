#!/bin/bash

# Log to screen
set -x

# Bootstrap node1
knife bootstrap ADDRESS --ssh-user USER --sudo --identity-file IDENTITY_FILE --node-name node1-centos --run-list 'recipe[learn_chef_httpd]'
