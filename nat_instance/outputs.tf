output "target_network_interface" {
    description = "Add 0.0.0.0/0 routes to this network interface in your route tables"
    value       = "dummy"
}

output "instance_id" {
    description = "Instance ID of the NAT instance (use for SSM debugging)"
    value       = "dummy"
}

output "elastic_ip" {
    description = "Elastic IP address of the NAT instance (maybe you need some allowlists?)"
    value       = "dummy"
}

output "security_group_id" {
    description = "Security group ID of the NAT instance (if extra rules are needed)"
    value       = "dummy"
}