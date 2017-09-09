variable "region" {
  description = "The AWS region to deploy the cluster in"
  default     = "us-east-2"
}

variable "ami_size" {
  description = "Size of the Chef EC2 Instances"
  default     = "t2.medium"
}

variable "key_name" {
  description = "Key Pair name for logging into AWS instances"
  default     = "learn-chef"
}

variable "public_key_path" {
  description = "Public key to use for SSH access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "node_count" {
  description = "Number of Chef node servers"
  default     = 2
}
