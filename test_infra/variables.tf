variable "test_count" {
  type        = number
  description = "Number of test instances to create"
  default     = 7
  validation {
    condition     = var.test_count >= 3 && var.test_count <= 50
    error_message = "test_count must be between 3 and 50"
  }
}

variable "test_bucket_name" {
  type        = string
  description = "Name of the test bucket"
  default     = ""
}