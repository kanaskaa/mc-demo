variable "product_code" {
  description = "Product code"
}
variable "env" {
  description = "Environment e.g. dev,preprod,prod"
}
variable "aws_region" {
  description = "Region in which to create network"
}
variable "availability_zones" {
  type = list
  description = "availabilty zone"
}
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
}
variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
  ap-south-1 = "ami-8da8d2e2"
  }
}
variable "subnets" {
  type = list
  description = "subnets EC2"
}
