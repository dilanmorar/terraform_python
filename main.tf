# set a provider
provider "aws" {
  region = "eu-west-1"
}

# create a vpc
resource "aws_vpc" "app_vpc"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.Name
  }
}

# internet gateway
resource "aws_internet_gateway" "app_internet_gateway"{
  vpc_id = aws_vpc.app_vpc.id
  tags = {
   Name = var.Name
   }
}

# create a subnet
resource "aws_subnet" "app_subnet"{
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = var.Name
  }
}

# route table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_internet_gateway.id
  }
  tags = {
   Name = var.Name
  }
}

# route table association
resource "aws_route_table_association" "app_association"{
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route_table.id
}

# create a security group
resource "aws_security_group" "app_security_dm" {
  name        = "app_security_dm"
  description = "Allow 80 TLS inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.Name
  }
}

# launch an instance
resource "aws_instance" "app_instance"{
  ami = var.ami-id
  subnet_id = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.app_security_dm.id]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.key_name
  user_data = data.template_file.app_init.rendered
  tags = {
    Name = "${var.Name}-python"
  }
}

# send template sh file
data  "template_file" "app_init" {
  template = "${file("./scripts/init_scripts.sh.tpl")}"
}
