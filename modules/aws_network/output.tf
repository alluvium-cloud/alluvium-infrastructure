output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "owner_id" {
  value = aws_vpc.vpc.owner_id
}

# output "public_subnets_id" {
#   value = ["${aws_subnet.public_subnet.*.id}"]
# }

output "public_subnets_id" {
  value = [
    for id in aws_subnet.public_subnet.*.id :
    format("%s", id)
  ]
}

output "private_subnets_id" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "security_groups_ids" {
  value = ["${aws_security_group.default.id}"]
}

output "public_rtb_id" {
  value = aws_route_table.public.id
}

output "private_rtb_id" {
  value = aws_route_table.private.id
}

output "default_rtb_id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "ssh_key_pair_id" {
  value = aws_key_pair.bastion.id
}
