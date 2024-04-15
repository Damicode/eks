
provider "aws" {
  region = var.region  # Replace with your desired AWS region.
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.S3 # change this
}
