data "aws_ami" "latest_amazon_linux" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# キーペア
resource "aws_key_pair" "key_pair" {
  key_name = "ssh_key"
  public_key = file("C:/Users/xxxxxx") # キーペアファイル  
}

# EC2インスタンス1a
resource "aws_instance" "instance1" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = aws_key_pair.key_pair.key_name
  tags = {
    Name = "EC2Instance1A"
  }

  depends_on = [aws_security_group.ec2_sg]
}

# EC2インスタンス1c
resource "aws_instance" "instance2" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = aws_key_pair.key_pair.key_name
  tags = {
    Name = "EC2Instance1C"
  }

  depends_on = [aws_security_group.ec2_sg]
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"  
  description = "Allow HTTP and SSH"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全トラフィック
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "ec2_sg"
  }
}
