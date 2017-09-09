# This security group allows intra-node communication on all ports with all
# protocols.
resource "aws_security_group" "chef-vpc" {
  name        = "chef-vpc"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id      = "${aws_vpc.chef.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags {
    Name    = "Chef Internal VPC"
    Project = "learn_chef"
  }
}

# This security group allows public ingress to the instances for HTTP and HTTPS
resource "aws_security_group" "chef-public-ingress" {
  name        = "chef-public-ingress"
  description = "Security group that allows public ingress to instances, HTTP, HTTPS and more."
  vpc_id      = "${aws_vpc.chef.id}"

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "Chef Public Access"
    Project = "learn_chef"
  }
}

# This security group allows public egress from the instances for HTTP and
# HTTPS, which is needed for yum updates, git access etc etc.
resource "aws_security_group" "chef-public-egress" {
  name        = "chef-public-egress"
  description = "Security group that allows egress to the internet for instances over HTTP and HTTPS."
  vpc_id      = "${aws_vpc.chef.id}"

  # HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "Chef Public Access"
    Project = "learn_chef"
  }
}

# Security group which allows SSH access to a host.
resource "aws_security_group" "chef-ssh" {
  name        = "chef-ssh"
  description = "Security group that allows public ingress over SSH."
  vpc_id      = "${aws_vpc.chef.id}"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "Chef SSH Access"
    Project = "learn_chef"
  }
}
