resource "aws_security_group" "damier_allow_tls" {
  name        = "damier_allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.damier_vpc.id



  tags = {
    Name = "damier_allow_tls"
  }
}
resource "aws_vpc_security_group_ingress_rule" "damier_sg1" {
  security_group_id = aws_security_group.damier_allow_tls.id

  cidr_ipv4   = aws_vpc.damier_vpc.cidr_block
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "damier_sg2" {
  security_group_id = aws_security_group.damier_allow_tls.id

  cidr_ipv4   = aws_vpc.damier_vpc.cidr_block
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
resource "aws_vpc_security_group_ingress_rule" "damier_allow_tls_ipv4" {
  security_group_id = aws_security_group.damier_allow_tls.id
  cidr_ipv4         = aws_vpc.damier_vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.damier_allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

