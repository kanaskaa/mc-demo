output "aws_infra" {
  description = "AWS infra network"
  value = "${
    map(
      "vpc_id", "${aws_vpc.aws_vpc_infra.id}"
    )
    }"
}

output "aws_infra_private_subnets" {
  value  = ["${aws_subnet.aws_subnet_infra-private-subnet.*.id}"]
}

output "aws_infra_public_subnets" {
  value  = ["${aws_subnet.aws_subnet_infra-public-subnet.*.id}"]
}

output "aws_infra_subnets" {
  description = "AWS SUbnets"
  value = "${
    map(
      "private_subnets", ["${aws_subnet.aws_subnet_infra-private-subnet.*.id}"],
      "public_subnets", ["${aws_subnet.aws_subnet_infra-public-subnet.*.id}"]
    )
    }"
}
