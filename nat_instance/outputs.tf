output "target_network_interface" {
    description = "Add 0.0.0.0/0 routes to this network interface in your route tables"
    value       = aws_network_interface.private_eni.id
}

output "instance_id" {
    description = "Instance ID of the NAT instance (use for SSM debugging)"
    value       = aws_instance.nat_instance.id
}

output "elastic_ip" {
    description = "Elastic IP address of the NAT instance (maybe you need some allowlists?)"
    value       = aws_eip.elastic_ip.public_ip
}

output "security_group_id" {
    description = "Security group ID of the NAT instance (if extra rules are needed)"
    value       = aws_security_group.security_group.id
}