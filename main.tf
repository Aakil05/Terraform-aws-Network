
# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = "192.168.0.0/16"
  
  tags = {
    Name = "network-vpc"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "network-public-az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "network-public-az2"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "network-igw"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "network-public-rt"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create private subnet az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "network-private-az1"
  }
}

# create private subnet az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.4.0/24"
  availability_zone       = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "network-private-az2"
  }
}

# create private subnet az3
resource "aws_subnet" "private_subnet_az3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.5.0/24"
  availability_zone       = data.aws_availability_zones.available_zones.names[2]

  tags = {
    Name = "network-private-az3"
  }
}

# allocate an elastic ip
resource "aws_eip" "elasticip" {
  vpc   = true
  tags = {
    Name = "network-eip"
  } 
}

#Create NAT gateway
resource "aws_nat_gateway" "Nat_gateway" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "network-gw-NAT"
  }
}

#create route table and add private route
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Nat_gateway.id
  }

  tags = {
    Name = "network-private-rt"
  }
}

# associate private subnet az1 to "private route table"
resource "aws_route_table_association" "private_subnet_1_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

# associate private subnet az2 to "private route table"
resource "aws_route_table_association" "private_subnet_2_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

# associate private subnet az3 to "private route table"
resource "aws_route_table_association" "private_subnet_3_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az3.id
  route_table_id = aws_route_table.private_route_table.id
}

#create security groups
resource "aws_security_group" "securitygrp" {
  name = "securitygrp"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks    = ["0.0.0.0/0"]
    description    = "HTTP Access"
    from_port      = 80
    protocol       = "tcp"
    to_port        = 80
  }
  ingress {
    cidr_blocks    = ["0.0.0.0/0"]
    description    = "SSH Access"
    from_port      = 22
    protocol       = "tcp"
    to_port        = 22
  }
  egress {
    cidr_blocks    = ["0.0.0.0/0"]
    description    = "All traffic"
    from_port      = 0
    protocol       = "-1"
    to_port        = 0
  }

  tags = {
    Name = "network-securitygrp"
  }
}
