output "test_instance_ids" {
  value = module.test_infra.test_instance_ids
}

output "nat_instance_id" {
  value = module.test_infra.nat_instance_id
}

output "nat_public_ip" {
  value = module.test_infra.elastic_ip
}