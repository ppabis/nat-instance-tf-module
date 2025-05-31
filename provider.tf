terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

variable "test_bucket_name" {
  type    = string
  default = ""
}

module "test_infra" {
  source           = "./test_infra"
  test_bucket_name = var.test_bucket_name
  test_count       = 7
}