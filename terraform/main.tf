resource "aws_vpc" "cyber_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "cyber-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.cyber_vpc.id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.cyber_vpc.id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "internal_ssh" {
  name        = "internal-ssh"
  description = "Allow SSH only between subnets"
  vpc_id      = aws_vpc.cyber_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.subnet_a_cidr, var.subnet_b_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "node_a" {
  ami                         = "ami-058c23b612018797a"  # Amazon Linux 2, eu-west-1
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.internal_ssh.id]
  associate_public_ip_address = false
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = "NodeA"
  }
}

resource "aws_instance" "node_b" {
  ami                         = "ami-058c23b612018797a"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_b.id
  vpc_security_group_ids      = [aws_security_group.internal_ssh.id]
  associate_public_ip_address = false
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = "NodeB"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("${path.module}/terraform-key.pub")
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-liv"
    key            = "episode2/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
