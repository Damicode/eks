data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


#Create Key Pairs
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
 resource "aws_key_pair" "deployer" {
   key_name   = var.key_name_tag
   public_key = tls_private_key.pk.public_key_openssh
 }

# Create Instance
resource "aws_instance" "damier_web_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name        = aws_key_pair.deployer.key_name

vpc_security_group_ids = [aws_security_group.damier_allow_tls.id]
subnet_id = aws_subnet.public_sub.id

  tags = {
    Name = var.aws_instance_tag
  }
}

# Create a Lock Id
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_state_lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "data_image1" {
  description = "Get All image available"
  value       = ["List of Images :${data.aws_ami.ubuntu.image_id}"]
  
}

output "ata_image2" {
  description = "Get All image available"
  value       = ["List of Images :${data.aws_ami.ubuntu.id}"] 
  
}