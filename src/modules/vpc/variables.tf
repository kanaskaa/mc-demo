variable "product_code" {
  description = "Product code"
}
variable "env" {
  description = "Environment e.g. dev,preprod,prod"
}
variable "aws_region" {
  description = "Region in which to create network"
}
variable "vpc_cidr" {
  description = "vpc cidr "
}
variable "route_table_cidr" {
  description = "route table cidr"
}
variable "availability_zones" {
  type = list
  description = "availabilty zone"
}
