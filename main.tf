#provisioning provider aws
provider "aws" {
  region     = "us-east-1"
  
}

#while creating a msk serverless cluster it is neccessary for vpc subnet and security groups
#create vpc for msk cluster
resource "aws_vpc" "msk_cluster_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}
#create SG for msk cluster
resource "aws_security_group" "example" {
  name = "kafka_security_group"
  vpc_id = aws_vpc.msk_cluster_vpc.id
  ingress  {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 9092
    to_port = 9092
    protocol = "tcp"
  }
  egress  {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}
#create subnets 1 & 2 for msk cluster
resource "aws_subnet" "kafka_subnet_1" {
    vpc_id = aws_vpc.msk_cluster_vpc.id
    cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "kafka_subnet_2" {
    vpc_id = aws_vpc.msk_cluster_vpc.id
    cidr_block = "10.0.2.0/24"
}


#create aws MSK serverless cluster 
resource "aws_msk_serverless_cluster" "kafka_msk" {
  cluster_name = "kafkamskcluster"
  tags = {
    kafka = "serverless"
  }
  vpc_config {
    subnet_ids = [aws_subnet.kafka_subnet_1.id,aws_subnet.kafka_subnet_2.id]
    security_group_ids = [aws_security_group.example.id]
  }
  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }
}

#creating msk_serverless_cluster for kafka, terraform is not supporting
#if creating aws_msk_cluster with this attribute itis possible for kafka
#but with aws_msk_serverless_cluster kafka is not supporting
