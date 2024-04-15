terraform {
  backend "s3" {
    bucket         = var.S3 
    key            = var.s3_key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.terraform
  }
}
