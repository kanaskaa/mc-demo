module "aws_dev_infra" {
 source = "../modules/vpc"

 aws_region = "${var.aws_region}"
 product_code = "${var.product_code}"
 env = "${var.env}"
 vpc_cidr = "${var.vpc_cidr}"
 route_table_cidr = "${var.route_table_cidr}"
 availability_zones = "${var.availability_zones}"
}

module "aws_dev_web" {
 source = "../modules/web"

 aws_region = "${var.aws_region}"
 product_code = "${var.product_code}"
 env = "${var.env}"
 availability_zones = "${var.availability_zones}"
 public_key_path = "${var.public_key_path}"
 key_name = "${var.key_name}"
 subnets = "${module.aws_dev_infra.aws_infra_subnets["public_subnets"]}"
}
