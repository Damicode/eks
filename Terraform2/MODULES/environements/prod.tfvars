terraform {
  backend "s3" {
    bucket         = "eks-cluster-bucket-damier"
    key            = "DamierProject/ENV/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_state_lock"
  }
}

instance_type   = "t3.large"
key_name        = "prod_newkey_pair"
aws_instance    = "prod_web_instance"
