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

📁 Files created/modified during boot on the NAT Instance:

- `/etc/sysctl.d/90-nat.conf` - enable IPv4 forwarding in kernel,
- `/etc/systemd/network/70-<ETH1>.network.d/routes.conf` - routes configuration for the ETH1 network card,
- `/etc/sysconfig/iptables` - IPTables config.

🧪 Testing
----------

The infrastructure can be tested by applying the root `provider.tf` file. It
will apply the module `test_infra` that further creates `nat_instance` module.
However, you need to do it in two steps:

- First do only: `tofu apply -target module.test_infra.aws_subnet.private_subnet`,
- Then do: `tofu apply`.

In normal use cases you should keep the NAT instance independent and only apply
changes if you add subnets but these should be ideally referenced with a data
source for example by a tag.

In the `test_infra` module I have created VPC Endpoints for SSM in one subnet
and S3 Gateway in another. Other subnets use pure NAT connectivity. This is to
mix some aspects and see if nothing break. There's also an S3 bucket for testing
the connectivity to S3. A cool idea is to run the following command to store
some info about the instance into this S3 bucket that you can then browse and
look for any issues. IP at the end should stay the same for each instance and
be equal to the Elastic IP of the NAT. Replace S3 bucket at the end with your
test bucket.

```bash
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
 && INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id` \
 && echo $INSTANCE_ID > ${INSTANCE_ID}.txt \
 && ip a >> ${INSTANCE_ID}.txt \
 && ip r >> ${INSTANCE_ID}.txt \
 && curl https://api.ipify.org/ >> ${INSTANCE_ID}.txt \
 && aws s3 cp ${INSTANCE_ID}.txt s3://test-bucket-123abcdef123/${INSTANCE_ID}.txt
```