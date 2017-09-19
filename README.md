# Work in Progress

This is a work in progress and should be used at your own risk!

# learn-chef-aws

Using Terraform, this will set up a Chef environment in the us-east-2 AWS region containing:
- 1 Chef Server
- 1 Chef Workstation
- 2 Chef Nodes
- 1 Bastion for ssh purposes

This will allow you to easily complete the Tracks on https://learn.chef.io/

## Usage

Within the Terraform directory:

```
terraform get

terraform plan

terraform apply
```

## Login

The exact IP addresses to use will be output at the end of the Terraform run. To access the EC2 instances, you will need to [authenticate using PKI]. By default, this will use `~/.ssh/id_rsa.pub` as your public key.

If you do not have an RSA key generated you can do the following:

```
ssh-keygen -t rsa
```

Make sure you have your local identity added:

```
ssh-add -K ~/.ssh/id_rsa
```

Example login:

```
ssh -A <HOSTNAME>
```

### Pro-tip

If you would like to make it so that you can just ssh directly into any of the Chef hosts from your local machine, set your `.ssh/config` to route traffic through the bastion like so:

```
Host bastion
 User ec2-user
 Hostname <ADD_BASTION_FQDN_HERE>
 IdentityFile ~/.ssh/id_rsa
 LogLevel Quiet

Host *.compute.internal
 User ec2-user
 IdentityFile ~/.ssh/id_rsa
 ProxyCommand ssh bastion -W %h:%p
 StrictHostKeyChecking no

Host *.compute.amazonaws.com
 User ec2-user
 IdentityFile ~/.ssh/id_rsa
 ProxyCommand ssh bastion -W %h:%p
 StrictHostKeyChecking no

Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa
```

This will also allow you to SSH/SCP between nodes directly.

## License

MIT. See LICENSE for details.

[authenticate using PKI]:https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/
