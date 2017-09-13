# Output some useful variables
output "chef-server_public_dns" {
  value = "${module.chef.chef-server_public_dns}"
}

output "chef-server_public_ip" {
  value = "${module.chef.chef-server_public_ip}"
}

output "chef-workstation_public_dns" {
  value = "${module.chef.chef-workstation_public_dns}"
}

output "chef-workstation_public_ip" {
  value = "${module.chef.chef-workstation_public_ip}"
}

output "chef-node_public_dns" {
  value = "${module.chef.chef-node_public_dns}"
}

output "chef-node_public_ip" {
  value = "${module.chef.chef-node_public_ip}"
}

output "chef-bastion_public_dns" {
  value = "${module.chef.chef-bastion_public_dns}"
}

output "chef-bastion_public_ip" {
  value = "${module.chef.chef-bastion_public_ip}"
}
