# Output some useful variables
output "chef_server_public_dns" {
  value = "${aws_instance.chef_server.public_dns}"
}

output "chef_server_public_ip" {
  value = "${aws_instance.chef_server.public_ip}"
}

output "chef_workstation_public_dns" {
  value = "${aws_instance.chef_workstation.public_dns}"
}

output "chef_workstation_public_ip" {
  value = "${aws_instance.chef_workstation.public_ip}"
}

output "chef_node_public_dns" {
  value = "${aws_instance.chef_node.*.public_dns}"
}

output "chef_node_public_ip" {
  value = "${aws_instance.chef_node.*.public_ip}"
}

output "chef_bastion_public_dns" {
  value = "${aws_instance.chef_bastion.*.public_dns}"
}

output "chef_bastion_public_ip" {
  value = "${aws_instance.chef_bastion.*.public_ip}"
}
