variable "Jenkins" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "JenkinsServer"
}
variable "Ansible" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "AnsibleServer"
}
variable "EKS" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "EKSClusterMasterPlane"
}

variable "S3" {
  default = "eks-cluster-bucket-damier"
}

variable "terraform" {
  default = "terraform_state_lock"
}
variable "s3_key" {
    default = "DamierProject/terraform.tfstate"
  
}


variable "Instance_type" {
  description = "Value of the EC2 instance type"
  
  type        = map(string)
  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "uat" = "t2.large"
    "prod" = "t2.xlarge"
  } 
}

variable "images" {
  default = "ami-0e731c8a588258d0d"
}
 variable "zone" {
    default = "us-east-1a"
   
 }

 variable "region" {
    default = "us-east-1"
   
 }
variable "cidr" {
  default = "10.0.0.0/16"
}

variable "sub1" {
  default = "10.0.0.0/24"
}
variable "sub2" {
  default = "10.0.0.0/24"
}


