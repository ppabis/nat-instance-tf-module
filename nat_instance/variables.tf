variable "vpc_id" {
  description = "VPC ID to create the NAT instance in"
  type        = string
}

variable "public_subnet" {
  description = "Public subnet ID to place the NAT instance in"
  type        = string
}

variable "private_subnets" {
  description = "IDs of private subnets that will be routed though the instance"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet) > 0
    error_message = "You must provide at least one private subnet ID"
  }
}

variable "create_ssm_role" {
  description = "Create an IAM role for SSM to debug the instance"
  type        = bool
  default     = false
}