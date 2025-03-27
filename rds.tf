resource "aws_db_instance" "db" {
  allocated_storage = 10
  db_name =  "wordpress"
  engine  = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  username       = "admin"
  password       = "xxxxxxxx"
  backup_retention_period = "0"
  db_subnet_group_name    = aws_db_subnet_group.db_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
}

resource "aws_db_subnet_group" "db_group" {
  name = "main"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "My DB Subnet group"
  }
}

resource "aws_security_group" "db_sg" {
  name = "rds-sg"
  description = "Allow db"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}