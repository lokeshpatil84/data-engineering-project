
variable "subnet_ids" {
  type = list(string)
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
