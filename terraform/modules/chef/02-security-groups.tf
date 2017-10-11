# Allows intra-node communication on all ports with all protocols.
resource "aws_security_group" "chef_vpc" {
  name        = "chef_vpc"
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

# Allows public ingress to the instances for HTTP and HTTPS.
resource "aws_security_group" "chef_public_ingress" {
  name        = "chef_public_ingress"
  description = "Security group that allows public ingress to instances over HTTP and HTTPS."
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
    Name    = "Chef Public Ingress"
    Project = "learn_chef"
  }
}

# Allows public egress from the instances over HTTP and HTTPS for yum updates, git access, etc.
resource "aws_security_group" "chef_public_egress" {
  name        = "chef_public_egress"
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
    Name    = "Chef Public Egress"
    Project = "learn_chef"
  }
}

# Security group which allows SSH access to a host.
resource "aws_security_group" "chef_ssh" {
  name        = "chef_ssh"
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
