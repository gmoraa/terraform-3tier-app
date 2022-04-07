# Read Default VPC
resource "aws_default_vpc" "default" {
}

# Read Default Subnet 'a'
resource "aws_default_subnet" "default_az1" {
  availability_zone         = "us-east-1a"
}

# Read Default Subnet 'b'
resource "aws_default_subnet" "default_az2" {
  availability_zone         = "us-east-1b"
}