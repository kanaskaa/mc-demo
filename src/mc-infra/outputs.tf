output "idpsandbox_aws_infra" {
  description = "IDP Sandbox vpc network"
  value = "${
    map(
    "vpc_id", "${module.aws_dev_infra.aws_infra["vpc_id"]}"
    )
  }"
}

output "idpsandbox_aws_infra_subnets" {
  value  = ["${module.aws_dev_infra.aws_infra_private_subnets}"]
}
