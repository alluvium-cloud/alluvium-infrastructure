# output "catapp_url" {
#   value = "http://${aws_eip.bastion.public_dns}"
# }

# output "catapp_ip" {
#   value = "http://${aws_eip.bastion.public_ip}"
# }

# output "vpc_id" {
#   value = aws_vpc.vpc.id
# }

# output "public_subnets_id" {
#   value = ["${aws_subnet.public_subnet.*.id}"]
# }

# output "private_subnets_id" {
#   value = ["${aws_subnet.private_subnet.*.id}"]
# }

# output "default_sg_id" {
#   value = aws_security_group.default.id
# }

# output "security_groups_ids" {
#   value = ["${aws_security_group.default.id}"]
# }

# output "public_route_table" {
#   value = aws_route_table.public.id
# }

output "vault_access_key" {
  value = module.vault_kms.vault_access_key
}
output "vault_secret_key" {
  value = module.vault_kms.vault_secret_key
}

output "vault_kms_key_id" {
  value = module.vault_kms.vault_kms_key_id
}
