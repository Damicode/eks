


#1 Create VPC
resource "aws_vpc" "damier_vpc" {
  cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

  tags = {
    Name = "Terraform_vpc"
  }
}

#2 Create Public Subnets
resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.damier_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a" 

  tags = {
    Name = "public_sub"
  }
}

#3 Create Private Subnets
resource "aws_subnet" "private_sub" {
  vpc_id     = aws_vpc.damier_vpc.id
  cidr_block = "10.0.128.0/20"
availability_zone = "us-east-1b" 
  tags = {
    Name = "private_sub"
  }
}

#4 Create internet gateway
resource "aws_internet_gateway" "damier_igw" {
  vpc_id  = aws_vpc.damier_vpc.id

  tags = {
    Name = "damier_igw"
  }
}

#4 Create Route Table
resource "aws_route_table" "damier_route_table" {
  vpc_id  = aws_vpc.damier_vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.damier_igw.id
  }

  

  tags = {

    Name = "damier_route_table"
  }
}

# 5 Create a rout Association
resource "aws_route_table_association" "damier_table_ra" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.damier_route_table.id
}



# 6 Create Eip  FOR Database Connectivity
resource "aws_eip" "damier_eip" {
  #domain = "vpc"
  vpc = true
  depends_on                = [aws_internet_gateway.damier_igw]
}

# Create NAT gateway
resource "aws_nat_gateway" "damier_nat_gateway" {
  allocation_id = aws_eip.damier_eip.id
  subnet_id     = aws_subnet.private_sub.id

  tags = {
    Name = "Damier Nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.damier_igw]
}