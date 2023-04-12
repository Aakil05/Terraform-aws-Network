

#aws security group cidr block
variable "allow_all" {
    default = ["0.0.0.0/0"]
}

#aws vpc cidr block
variable "vpc_cidr_block" {
    default = "192.168.0.0/16"
}

#aws subnet public az1
variable "public_subnet_az1" {
  default = "192.168.1.0/24"
}

#aws subnet public az2
variable "public_subnet_az2" {
  default = "192.168.2.0/24"
}

#aws subnet private az1
variable "private_subnet_az1" {
  default = "192.168.3.0/24"
}

#aws subnet private az2
variable "private_subnet_az2" {
  default = "192.168.4.0/24"
}

#aws subnet private az3
variable "private_subnet_az3" {
  default = "192.168.5.0/24"
}
