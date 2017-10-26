# Null resource to copy keys from chef_server to chef_workstation.
#   Will not run until chef_server and chef_workstation have completed.
resource "null_resource" "copy_key" {
  depends_on = ["aws_instance.chef_server", "aws_instance.chef_workstation"]

  connection {
    host                = "${aws_instance.chef_server.private_ip}"
    user                = "ec2-user"
    private_key         = "${file("~/.ssh/id_rsa")}"
    bastion_host        = "${aws_instance.chef_bastion.public_dns}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    content     = "${file("~/.ssh/id_rsa")}"
    destination = "/tmp/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /tmp/id_rsa",
      "scp -i /tmp/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /drop/chefadmin.pem ${aws_instance.chef_workstation.public_dns}:/home/ec2-user/chef-repo/.chef/chefadmin.pem",
      "rm -f /tmp/id_rsa",
    ]
  }
}

# Null resource to setup SSL for chef_workstation to chef_server
resource "null_resource" "ssl_setup_and_cookbook_upload" {
  depends_on = ["null_resource.copy_key"]

  connection {
    host                = "${aws_instance.chef_workstation.private_ip}"
    user                = "ec2-user"
    private_key         = "${file("~/.ssh/id_rsa")}"
    bastion_host        = "${aws_instance.chef_bastion.public_dns}"
    bastion_user        = "ec2-user"
    bastion_private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "pushd /home/ec2-user/chef-repo && knife ssl fetch && knife ssl check && popd",
      "pushd /home/ec2-user/chef-repo/cookbooks",
      "git clone https://github.com/learn-chef/learn_chef_httpd.git",
      "knife cookbook upload learn_chef_httpd",
      "knife cookbook list",
      "popd",
    ]
  }

  provisioner "file" {
    content     = "${file("~/.ssh/id_rsa")}"
    destination = "/tmp/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /tmp/id_rsa",
      "${data.template_file.bootstrap_nodes.rendered}",
      "rm -f /tmp/id_rsa",
    ]
  }
}
