terraform {
  backend "s3" {
    bucket         = "eks-cluster-bucket-damier"
    key            = "DamierProject/ENV/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_state_lock"
  }
}

instance_type   = "t2.micro"
key_name_tag        = "dev_newkey_pair"
aws_instance    = "dev_web_instance"
