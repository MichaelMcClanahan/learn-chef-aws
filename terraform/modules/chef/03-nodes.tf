# Define RHEL 7.3 AMI
data "aws_ami" "rhel7_3" {
  most_recent = true

  owners = ["309956199498"] # Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["RHEL-7.3*"]
  }
}

# Create SSH Key Pair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# Load the script to prepare the Chef server
data "template_file" "server_install" {
  template = "${file("${path.module}/files/server_install.sh")}"
}

# Load the script to prepare the Chef workstation
data "template_file" "workstation_install" {
  template = "${file("${path.module}/files/workstation_install.sh")}"
}

# Load the script to prepare the Chef node(s)
data "template_file" "node_install" {
  template = "${file("${path.module}/files/node_install.sh")}"
}

# Create Chef Server
resource "aws_instance" "chef-server" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  user_data     = "${data.template_file.server_install.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-public-ingress.id}",
    "${aws_security_group.chef-public-egress.id}",
    "${aws_security_group.chef-ssh.id}",
  ]
  root_block_device {
    volume_size = 40
  }
  tags {
    Name    = "Chef Server"
    Project = "learn_chef"
  }
}

# Create Chef Workstation
resource "aws_instance" "chef-workstation" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  user_data     = "${data.template_file.workstation_install.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-public-ingress.id}",
    "${aws_security_group.chef-public-egress.id}",
    "${aws_security_group.chef-ssh.id}",
  ]
  root_block_device {
    volume_size = 40
  }
  tags {
    Name    = "Chef Workstation"
    Project = "learn_chef"
  }
}

# Create Chef Node(s)
resource "aws_instance" "chef-node" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  user_data     = "${data.template_file.node_install.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-public-ingress.id}",
    "${aws_security_group.chef-public-egress.id}",
    "${aws_security_group.chef-ssh.id}",
  ]
  root_block_device {
    volume_size = 40
  }
  tags {
    Name    = "Chef Node ${format(count.index + 1)}"
    Project = "learn_chef"
  }
  count = "${var.node_count}"
}
