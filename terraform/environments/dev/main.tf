
module "network" {
  source = "../../modules/network"
}

module "iam" {
  source = "../../modules/iam"
}

module "storage" {
  source = "../../modules/storage"
  env    = "dev"
}

# Upload Script to S3
resource "aws_s3_object" "script" {
  bucket = module.storage.bucket_name
  key    = "scripts/glue_iceberg_etl.py"
  source = "../../../src/scripts/glue_iceberg_etl.py"
  etag   = filemd5("../../../src/scripts/glue_iceberg_etl.py")
}

module "database" {
  source      = "../../modules/database"
  subnet_id   = module.network.private_subnet_id
  sg_id       = module.network.security_group_id
  db_password = var.db_password
}

module "glue" {
  source       = "../../modules/glue"
  bucket_name  = module.storage.bucket_name
  role_arn     = module.iam.glue_role_arn
  script_key   = aws_s3_object.script.key
  db_endpoint  = module.database.endpoint
  db_username  = module.database.username
  db_password  = var.db_password
  subnet_id    = module.network.private_subnet_id
  sg_id        = module.network.security_group_id
}