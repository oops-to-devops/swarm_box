data "aws_ami" "app_server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    #    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}

# sim-vpc-ap-southeast-1
data "aws_vpc" "app_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet" "pub_subnet1" {
  tags = {
    Name = var.subnet_name
  }
}

data "aws_security_group" "sg-bastion" {
  tags = {
    Name = var.security_group_name
  }
}
