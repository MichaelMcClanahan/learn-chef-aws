# Define the VPC.
resource "aws_vpc" "chef" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name    = "Chef VPC"
    Project = "learn_chef"
  }
}

# Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "chef" {
  vpc_id = "${aws_vpc.chef.id}"

  tags {
    Name    = "Chef IGW"
    Project = "learn_chef"
  }
}

# Create a public subnet.
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.chef.id}"
  cidr_block              = "${var.subnet_cidr}"
  availability_zone       = "${var.subnet_az}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.chef"]

  tags {
    Name    = "Chef Public Subnet"
    Project = "learn_chef"
  }
}

# Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.chef.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.chef.id}"
  }

  tags {
    Name    = "Chef Public Route Table"
    Project = "learn_chef"
  }
}

# Associate the route table with the public subnet allowing access to internet.
resource "aws_route_table_association" "public-subnet" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
