resource "aws_instance" "web" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  user_data = file("script.sh")
  security_groups = [aws_security_group.webapp_SG.name]
  key_name = "webpoint_key"

  tags = {
    Name = "webpoint-ec2"
  }
}

resource "aws_key_pair" "webpoint_key" {
  key_name   = "webpoint_key"
  public_key = tls_private_key.rsa.public_key_openssh
}


# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "webpoint_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "webpointkey"
}

resource "aws_security_group" "webapp_SG" {
  name        = "security group webapp"
  description = "security group webapp"
  vpc_id      = "vpc-0b23c7ab9d0828203"


  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "webapp"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "webapp_SG"
  }
}
