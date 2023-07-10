# Credentials
variable "AWS_ACCESS_KEY_ID"{
  type = string
}

variable "AWS_SECRET_ACCESS_KEY"{
  type = string
}

variable "aws_region" {
  default = "sa-east-1"
}

provider "aws" {
    region = var.aws_region
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}

# Create a vpc
resource "aws_vpc" "project-main-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "project-1"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.project-main-vpc.id

  tags = {
    Name = "project-1"
  }
}

# Create a Custom Route Table
resource "aws_route_table" "project-route-table" {
  vpc_id = aws_vpc.project-main-vpc.id


  route {
    cidr_block = "0.0.0.0/0" # Default route: All ipv4 traffic it send to the Internet Gateway
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0" # Default route: All ipv6 traffic it send to the Internet Gateway
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "project-1"
  }
}

# Create a Subnet
resource "aws_subnet" "project-subnet-1" {
  vpc_id = aws_vpc.project-main-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "project-1"
  }
}

# Associate Subnet with the Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.project-subnet-1.id
  route_table_id = aws_route_table.project-route-table.id
}

# Create a Security Group to allow port 22, 80, 443
resource "aws_security_group" "project-allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.project-main-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "project-1"
  }
}

# Create a Network interface with an IP in the previous subnet
resource "aws_network_interface" "project-network_interface" {
  subnet_id       = aws_subnet.project-subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.project-allow_web.id]
}

# Assing an elastic IP to the network interface
resource "aws_eip_association" "project-elastic_ip_assoc" {
  instance_id   = aws_instance.project-instance_web_server.id
  allocation_id = aws_eip.project-elastic_ip.id
}

resource "aws_eip" "project-elastic_ip" {
  domain = "vpc"
  network_interface = aws_network_interface.project-network_interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.gw ]
}

# Create an Ubuntu server and install apache2
resource "aws_instance" "project-instance_web_server" {
    ami               = "ami-0af6e9042ea5a4e3e"
    availability_zone = "sa-east-1a"
    instance_type     = "t2.micro"
    key_name = "project-main-key"
    
    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.project-network_interface.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo first web server > /var/www/html/index.html'
                EOF


    tags = {
      Name = "project-1"
    }
}
