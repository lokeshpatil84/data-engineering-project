
resource "aws_s3_bucket" "datalake" {
  bucket = "de-iceberg-datalake-${var.env}-${formatdate("YYYYMMDD", timestamp())}"
  force_destroy = true 
}
