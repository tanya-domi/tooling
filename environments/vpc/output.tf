

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.arctiqvpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.arctiqvpc.cidr_block
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  value = aws_subnet.prodpublic.*.id
}

output "node_role" {
  value = aws_iam_role.nodes.arn
}

output "master_role" {
  value = aws_iam_role.master.arn
}

output "arctiq-sg" {
  value = aws_security_group.prodvpc-sg.id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_nat_gateway.arctiq_natgw.*.public_ip
}


output "azs" {
  description = "A list of availability zones "
  value       = var.azs
}

output "public_subnet_ids" {
  value = aws_subnet.prodpublic[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}


