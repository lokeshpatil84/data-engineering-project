provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "data-engineer-destination-bucket-123"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}