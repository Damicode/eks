variable "S3" {
    type = "String"
  default = "eks-cluster-bucket-damier2_modules"
}

variable "terraform" {
  default = "terraform_state_lock"
}
variable "s3_key" {
    default = "DamierProject/terraform.tfstate"
  
}

variable "instance_type"{
  type = String
  
}

variable "key_name_tag"{
  type = String
  
}

variable "aws_instance_tag"{
  type = String
  
  
}

variable "private_sub"{
  description = "Cidr for private subnets"
  default = "10.0.128.0/20"
  
  
}

variable "pub_sub"{
  description = "Cidr for public subnets"
  default = "10.0.0.0/24"

  
  
}

variable "vpc_cidr"{
  description = "Cidr for VPC"
  default = "10.0.0.0/16"

  
  
}


