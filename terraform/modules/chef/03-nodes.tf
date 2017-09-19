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

# # Load the script to prepare the Chef server
# data "template_file" "server_install" {
#   template = "${file("${path.module}/files/server_install.sh")}"

#   vars = {
#     workstation_public_dns  = "${aws_instance.chef-workstation.public_dns}"
#   }
# }

# # Load the script to prepare the Chef workstation
# data "template_file" "workstation_install" {
#   template = "${file("${path.module}/files/workstation_install.sh")}"

#   vars = {
#     server_public_dns  = "${aws_instance.chef-server.public_dns}"
#   }
# }

# # Load the script to prepare the Chef node(s)
# data "template_file" "node_install" {
#   template = "${file("${path.module}/files/node_install.sh")}"
# }

# Create Chef Server
resource "aws_instance" "chef-server" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  # user_data     = "${data.template_file.server_install.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-public-ingress.id}",
    "${aws_security_group.chef-public-egress.id}",
  ]
  tags {
    Name    = "Chef Server"
    Project = "learn_chef"
  }

  # provisioner "remote-exec" {
  #   script = "${path.module}/files/server_install.sh"

  #   connection {
  #     host                = "${aws_instance.chef-server.private_ip}"
  #     user                = "ec2-user"
  #     private_key         = "${file("~/.ssh/id_rsa")}"
  #     bastion_host        = "${aws_instance.chef-bastion.public_dns}"
  #     bastion_user        = "ec2-user"
  #     bastion_private_key = "${file("~/.ssh/id_rsa")}"
  #   }
  # }
}

# Create Chef Workstation
resource "aws_instance" "chef-workstation" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  # user_data     = "${data.template_file.workstation_install.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-public-egress.id}",
  ]
  tags {
    Name    = "Chef Workstation"
    Project = "learn_chef"
  }

  # provisioner "remote-exec" {
  #   script = "${path.module}/files/workstation_install.sh"

  #   connection {
  #     host                = "${aws_instance.chef-workstation.private_ip}"
  #     user                = "ec2-user"
  #     private_key         = "${file("~/.ssh/id_rsa")}"
  #     bastion_host        = "${aws_instance.chef-bastion.public_dns}"
  #     bastion_user        = "ec2-user"
  #     bastion_private_key = "${file("~/.ssh/id_rsa")}"
  #   }
  # }
}

# Create Chef Node(s)
resource "aws_instance" "chef-node" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "${var.ami_size}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  # user_data     = "${data.template_file.node_install.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-public-egress.id}",
  ]
  tags {
    Name    = "Chef Node ${format(count.index + 1)}"
    Project = "learn_chef"
  }
  count = "${var.node_count}"

  provisioner "remote-exec" {
    script = "${path.module}/files/node_install.sh"

    connection {
      host                = "${self.private_ip}"
      user                = "ec2-user"
      private_key         = "${file("~/.ssh/id_rsa")}"
      bastion_host        = "${aws_instance.chef-bastion.public_dns}"
      bastion_user        = "ec2-user"
      bastion_private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

# Create Chef Bastion
resource "aws_instance" "chef-bastion" {
  ami           = "${data.aws_ami.rhel7_3.id}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  key_name      = "${aws_key_pair.keypair.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.chef-vpc.id}",
    "${aws_security_group.chef-ssh.id}",
    "${aws_security_group.chef-public-egress.id}",
  ]

  tags {
    Name    = "Chef Bastion"
    Project = "learn_chef"
  }
}
