# Define RHEL 7.3 AMI.
data "aws_ami" "rhel7_3" {
  most_recent = true

  owners = ["309956199498"]

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

# Create SSH Key Pair.
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# Create Chef Server.
resource "aws_instance" "chef_server" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.chef_vpc.id}",
    "${aws_security_group.chef_public_ingress.id}",
    "${aws_security_group.chef_public_egress.id}",
  ]

  tags {
    Name    = "Chef Server"
    Project = "learn_chef"
  }

  connection {
    host                = "${self.private_ip}"
    user                = "ec2-user"
    private_key         = "${file("~/.ssh/id_rsa")}"
    bastion_host        = "${aws_instance.chef_bastion.public_dns}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "${path.module}/files/server_install.sh"
    destination = "/tmp/server_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/server_install.sh",
      "sudo /tmp/server_install.sh",
    ]
  }
}

# Load the script for the workstation install.
#   We do this because the workstation_install.sh script needs to
#   interpolate the value of the chef_server public DNS.
data "template_file" "workstation_install" {
  template = "${file("${path.module}/files/workstation_install.sh")}"

  vars {
    chef_server = "${aws_instance.chef_server.public_dns}"
  }
}

# Create Chef Workstation
resource "aws_instance" "chef_workstation" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.chef_vpc.id}",
    "${aws_security_group.chef_public_egress.id}",
  ]

  tags {
    Name    = "Chef Workstation"
    Project = "learn_chef"
  }

  connection {
    host                = "${self.private_ip}"
    user                = "ec2-user"
    private_key         = "${file("~/.ssh/id_rsa")}"
    bastion_host        = "${aws_instance.chef_bastion.public_dns}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "${data.template_file.workstation_install.rendered}",
    ]
  }
}

# Create Chef Node(s).
resource "aws_instance" "chef_node" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"
  count         = "${var.node_count}"

  vpc_security_group_ids = [
    "${aws_security_group.chef_vpc.id}",
    "${aws_security_group.chef_public_egress.id}",
  ]

  tags {
    Name    = "Chef Node ${format(count.index + 1)}"
    Project = "learn_chef"
  }

  connection {
    host                = "${self.private_ip}"
    user                = "ec2-user"
    private_key         = "${file("~/.ssh/id_rsa")}"
    bastion_host        = "${aws_instance.chef_bastion.public_dns}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "${path.module}/files/node_install.sh"
    destination = "/tmp/node_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/node_install.sh",
      "sudo /tmp/node_install.sh",
    ]
  }
}

# Create Chef Bastion.
resource "aws_instance" "chef_bastion" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.chef_vpc.id}",
    "${aws_security_group.chef_ssh.id}",
    "${aws_security_group.chef_public_egress.id}",
  ]

  tags {
    Name    = "Chef Bastion"
    Project = "learn_chef"
  }
}
