provider "aws" {
  region = "ap-south-1"
  profile = "default"
}

data "aws_vpc" "myvpc" {
  default = true
}

data "aws_subnet_ids" "mysubnet" {
  vpc_id = data.aws_vpc.myvpc.id
}

resource "aws_security_group" "default" {
  name        = "main_rds_sg"
  description = "Allow all inbound traffic"
  vpc_id      = data.aws_vpc.myvpc.id


  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "wordpress-db"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main_subnet_group"
  subnet_ids = data.aws_subnet_ids.mysubnet.ids
}

resource "aws_db_instance" "mydb" {
  allocated_storage      = "10"
  publicly_accessible    = true
  identifier             = "wordpress-db"
  engine                 = "mariadb"
  engine_version         = "10.4.8"
  instance_class         = "db.t2.micro"
  name                   = "mydatabase"
  username               = "satyam"
  password               = "password123"
  vpc_security_group_ids = [aws_security_group.default.id]
  db_subnet_group_name   = aws_db_subnet_group.default.id
  skip_final_snapshot    = true
}