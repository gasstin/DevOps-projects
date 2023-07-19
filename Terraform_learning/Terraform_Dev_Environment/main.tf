# Creating a VPC
resource "aws_vpc" "dev_environment_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Dev_environment"
  }
}

# Creating a Subne
resource "aws_subnet" "dev_environment_subnet" {
  vpc_id                  = aws_vpc.dev_environment_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"

  tags = {
    Name = "Dev_environment"
  }
}

# Creating a Internet Gateway
resource "aws_internet_gateway" "dev_environment_gw" {
  vpc_id = aws_vpc.dev_environment_vpc.id

  tags = {
    Name = "Dev_environment"
  }
}

# Creating a Route table
resource "aws_route_table" "dev_environment_route_table" {
  vpc_id = aws_vpc.dev_environment_vpc.id

  tags = {
    Name = "Dev_environment"
  }
}

resource "aws_route" "dev_environment_route" {
  route_table_id         = aws_route_table.dev_environment_route_table.id
  destination_cidr_block = "0.0.0.0/0" # All IP addresses
  gateway_id             = aws_internet_gateway.dev_environment_gw.id
}

# Associate the Route table with the Subnet
resource "aws_route_table_association" "dev_environment_route_table_association" {
  subnet_id      = aws_subnet.dev_environment_subnet.id
  route_table_id = aws_route_table.dev_environment_route_table.id
}

# Creating a Security group
resource "aws_security_group" "dev_environment_security_group" {
  name        = "dev_environment_sg"
  description = "Dev security group"
  vpc_id      = aws_vpc.dev_environment_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Change for your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all IP addresses
  }

}

# Using a key pair created via ssh-keygen
resource "aws_key_pair" "dev_environment_key_pair" {
  key_name   = "dev_key"
  public_key = file("~/.ssh/dev_environment_key.pub")
}

# Creating EC2 instances
resource "aws_instance" "dev_environment_node" {
  instance_type          = "t4g.small"
  ami                    = data.aws_ami.dev_environment_ami.id
  key_name               = aws_key_pair.dev_environment_key_pair.id
  vpc_security_group_ids = [aws_security_group.dev_environment_security_group.id]
  subnet_id              = aws_subnet.dev_environment_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Dev_environment"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "ubuntu"
      Identityfile = "~/.ssh/project-main-key.ppk"
    })
    interpreter = var.host_os == "linux" ? ["bash", "-c"] : ["PowerShell", "Command"] # Conditionals
  }
}

output "public_ip" {
  value = aws_instance.dev_environment_node.public_ip
}