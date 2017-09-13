# Work in Progress

This is a work in progress and should be used at your own risk!

# learn-chef-aws

Using Terraform, this will set up a Chef environment in the us-east-2 AWS region containing:
- 1 Chef Server
- 1 Chef Workstation
- 2 Chef Nodes

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
ssh -A ec2-user@<PUBLIC_IPADDRESS>
```

## License

MIT. See LICENSE for details.

[authenticate using PKI]:https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/
