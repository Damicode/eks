variable "S3" {
    type = "String"
  default = "eks-cluster-bucket-damier"
}

variable "terraform" {
  default = "terraform_state_lock"
}
variable "s3_key" {
    default = "DamierProject/terraform.tfstate"
  
}