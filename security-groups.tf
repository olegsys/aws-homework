#--------------Security Groups--------------
resource "aws_security_group" "allow_ssh-a" {
  vpc_id = aws_vpc.wordpress_a.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "allow_ssh"
  }
}
resource "aws_security_group" "allow_ssh-b" {
  vpc_id = aws_vpc.wordpress_b.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "allow_ssh"
  }
}
resource "aws_security_group" "allow_web-a" {
  vpc_id = aws_vpc.wordpress_a.id
  name   = "allow web"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_a_cidr}", "${var.vpc_b_cidr}"]
  }
  tags = {
    "Name" = "allow_web"
  }
}
resource "aws_security_group" "allow_web-b" {
  vpc_id = aws_vpc.wordpress_b.id
  name   = "allow web"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_a_cidr}", "${var.vpc_b_cidr}"]
  }
  tags = {
    "Name" = "allow_web"
  }
}
resource "aws_security_group" "sg-efs" {
  vpc_id = aws_vpc.wordpress_a.id
  name   = "allow nfs"
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_a_cidr}", "${var.vpc_b_cidr}"]
  }
  tags = {
    "Name" = "allow nfs"
  }
}
resource "aws_security_group" "mysql_open" {
  vpc_id = aws_vpc.mysql-db-vpc.id
  name   = "allow mysql"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_a_cidr}", "${var.vpc_b_cidr}"]
  }
  tags = {
    "Name" = "allow mysql"
  }
}
