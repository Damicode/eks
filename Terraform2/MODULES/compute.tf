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
resource "aws_key_pair" "deployer" {
  key_name   = "damier_newkey_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create Instance
resource "aws_instance" "damier_web_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name        = aws_key_pair.deployer.key_name

vpc_security_group_ids = [aws_security_group.damier_allow_tls.id]
subnet_id = aws_subnet.public_sub.id

  tags = {
    Name = "damier_web_instance1"
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
  value       = "List of Images :${data.aws_ami.ubuntu}/" 
  
}

output "ata_image2" {
  description = "Get All image available"
  value       = "List of Images :${data.aws_ami.ubuntu.id}/" 
  
}