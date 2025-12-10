variable "subnet_id" {
  type        = string
  description = "Subnet ID for AWS Glue Job networking"
}

variable "sg_id" {
  type        = string
  description = "Security Group ID for AWS Glue Job"
}

variable "db_password" {
  type        = string
  description = "Database password for Glue connection"
  sensitive   = true
}
