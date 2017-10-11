# Output some useful variables
output "chef_server_public_dns" {
  value = "${module.chef.chef_server_public_dns}"
}

output "chef_server_public_ip" {
  value = "${module.chef.chef_server_public_ip}"
}

output "chef_workstation_public_dns" {
  value = "${module.chef.chef_workstation_public_dns}"
}

output "chef_workstation_public_ip" {
  value = "${module.chef.chef_workstation_public_ip}"
}

output "chef_node_public_dns" {
  value = "${module.chef.chef_node_public_dns}"
}

output "chef_node_public_ip" {
  value = "${module.chef.chef_node_public_ip}"
}

output "chef_bastion_public_dns" {
  value = "${module.chef.chef_bastion_public_dns}"
}

output "chef_bastion_public_ip" {
  value = "${module.chef.chef_bastion_public_ip}"
}
