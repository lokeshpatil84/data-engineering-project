variable "bucket_name" {}
variable "role_arn" {}
variable "script_key" {}
variable "db_endpoint" {}
variable "db_password" {}
variable "db_username" {}
variable "subnet_id" {}
variable "sg_id" {}

# --- CHANGE: Connection resource ki ab zarurat nahi hai (Comment/Remove kar diya) ---
# resource "aws_glue_connection" "rds_conn" {
#   name = "postgres_connection"
#   ...
# }

resource "aws_glue_catalog_database" "iceberg_db" {
  name = "iceberg_lake_db"
}

resource "aws_glue_job" "etl" {
  name     = "postgres_to_iceberg_job"
  role_arn = var.role_arn
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2

  command {
    script_location = "s3://${var.bucket_name}/${var.script_key}"
    python_version  = "3"
  }

  # --- IMPORTANT FIX: Connections line ko hata diya ---
  # connections = [aws_glue_connection.rds_conn.name] 

  default_arguments = {
    "--job-language"                     = "python"
    "--datalake-formats"                 = "iceberg"
    "--conf"                             = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
    "--iceberg_s3_path"                  = "s3://${var.bucket_name}/warehouse/"
    "--db_password"                      = var.db_password
    "--db_url"                           = "jdbc:postgresql://${var.db_endpoint}:5432/source_db"
    "--db_user"                          = var.db_username
  }
}