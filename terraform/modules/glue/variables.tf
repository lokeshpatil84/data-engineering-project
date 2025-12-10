variable "bucket_name" {
  type        = string
  description = "S3 bucket name jaha Glue script store hoga"
}

variable "role_arn" {
  type        = string
  description = "IAM Role ARN used by AWS Glue"
}

variable "script_key" {
  type        = string
  description = "S3 key/path for Glue ETL script"
}

variable "db_endpoint" {
  type        = string
  description = "Postgres DB endpoint URL"
}

variable "db_username" {
  type        = string
  description = "Database username for connection"
}

variable "db_password" {
  type        = string
  description = "Database password for Glue job"
  sensitive   = true
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for Glue job networking"
}

variable "sg_id" {
  type        = string
  description = "Security Group ID for Glue job"
}
