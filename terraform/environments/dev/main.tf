variable "db_password" {}

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

resource "aws_s3_object" "script" {
  bucket = module.storage.bucket_name
  key    = "scripts/glue_iceberg_etl.py"
  source = "../../../src/scripts/glue_iceberg_etl.py"
  etag   = filemd5("../../../src/scripts/glue_iceberg_etl.py")
}

# --- FIX START ---

module "database" {
  source      = "../../modules/database"
  
  # ✅ FIX 1: Variable name 'subnet_ids' (plural) hona chahiye
  # ✅ FIX 2: Value 'private_subnet_ids' (list) honi chahiye
  subnet_ids  = module.network.private_subnet_ids
  
  sg_id       = module.network.security_group_id
  db_password = var.db_password
}

module "glue" {
  source       = "../../modules/glue"
  
  # ✅ FIX 3: Glue ko single 'subnet_id' chahiye
  subnet_id    = module.network.primary_subnet_id
  
  bucket_name  = module.storage.bucket_name
  role_arn     = module.iam.glue_role_arn
  script_key   = aws_s3_object.script.key
  db_endpoint  = module.database.endpoint
  db_username  = module.database.username
  db_password  = var.db_password
  sg_id        = module.network.security_group_id
}