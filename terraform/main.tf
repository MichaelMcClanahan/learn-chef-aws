# Create provider to setup into AWS
provider "aws" {
  region = "${var.region}"
}

# Create Chef cluster using a module
module "chef" {
  source = "./modules/chef"
  region = "${var.region}"

  ami_size        = "${var.ami_size}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  node_count      = "${var.node_count}"
}
