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

This will use `~/.ssh/id_rsa.pub` as your public key. The exact IP addresses to use will be output at the end of the Terraform run.

Example login:

```
ssh -i ~/.ssh/id_rsa.pub ec2-user@<PUBLIC_IPADDRESS>
```

## License

MIT. See LICENSE for details.
