NAT Instance Terraform Module
===============

This repository presents (another one) NAT Instance example on AWS.

The inputs to the module are the following:

- `vpc_id` - which VPC create NAT Instance's Security Group
- `public_subnet` - where to place the VPC Instance,
- `private_subnets` - list of subnets that will be hidden behind NAT. The first
  subnet will be used to place an Elastic Network Interface that will be the
  target of the Internet route,
- `create_ssm_role` - optionally the module can create an Instance Profile and
  IAM role to use for debugging the instance. It will allow the instance to
  register with AWS Systems Manager so that an administrator can reach it via
  Session Manager.

The module providers the following outputs:

- `target_network_interface` - to this ENI you should route your Internet
  traffic (so the route `0.0.0.0/0`),
- `instance_id` - ID of the instance. This can be used to establish SSM Session
  via CLI, with `aws ssm start-sesion --target $(tofu output -raw instance_id)`,
- `elastic_ip` - public IP of the NAT Instance. Can be used for allowlists,
- `security_group_id` - in case you need to add extra rules to the Security
  Group or reference it somewhere else, it is provided.

The following resources will be created by the module:

- `aws_instance` - the NAT Instance,
- `aws_eip` - Elastic public IP,
- `aws_security_group` - the security group, shared by ENIs,
- two `aws_network_interface` resources - one is tied directly to the instance
  (public one that will be in the public subnet), and another will be created in
  the first subnet on the list in `private_subnets`,
- optionally `aws_iam_role` and `aws_instance_profile` - used for SSM Sessions.
  Attached policy is the default `AWSManagedInstanceCore` policy.
