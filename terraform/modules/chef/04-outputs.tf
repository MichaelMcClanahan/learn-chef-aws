# Output some useful variables
output "chef-server_public_dns" {
  value = "${aws_instance.chef-server.public_dns}"
}

output "chef-server_public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}

output "chef-workstation_public_dns" {
  value = "${aws_instance.chef-workstation.public_dns}"
}

output "chef-workstation_public_ip" {
  value = "${aws_instance.chef-workstation.public_ip}"
}

output "chef-node_public_dns" {
  value = "${aws_instance.chef-node.*.public_dns}"
}

output "chef-node_public_ip" {
  value = "${aws_instance.chef-node.*.public_ip}"
}

output "chef-bastion_public_dns" {
  value = "${aws_instance.chef-bastion.*.public_dns}"
}

output "chef-bastion_public_ip" {
  value = "${aws_instance.chef-bastion.*.public_ip}"
}
