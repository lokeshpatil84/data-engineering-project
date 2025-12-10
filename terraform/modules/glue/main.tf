
# 1. Glue Connection to RDS (VPC ke andar)
resource "aws_glue_connection" "rds_conn" {
  name = "postgres_connection"
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:postgresql://${var.db_endpoint}:5432/source_db"
    USERNAME            = var.db_username
    PASSWORD            = var.db_password
  }
  physical_connection_requirements {
    availability_zone      = "ap-south-1a"
    security_group_id_list = [var.sg_id]
    subnet_id              = var.subnet_id
  }
}

# 2. Glue Database for Iceberg Tables
resource "aws_glue_catalog_database" "iceberg_db" {
  name = "iceberg_lake_db"
}

# 3. Glue Job
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

  connections = [aws_glue_connection.rds_conn.name]

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