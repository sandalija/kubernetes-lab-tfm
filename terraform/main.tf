resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_key_pair" "deployer" {
  key_name   = "cluster-public-key"
  public_key = file(var.public_key_path)
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.aws_availability_zone
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "private_ec2_sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Internal SSH only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "control_plane" {
  ami                    = var.flatcar_ami
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  private_ip             = "10.0.2.135"
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "control-plane"
  }
}

resource "aws_instance" "worker_1" {
  ami                    = var.flatcar_ami
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  private_ip             = "10.0.2.163"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "worker-1"
  }
}

resource "aws_instance" "worker_2" {
  ami                    = var.flatcar_ami
  instance_type          = "t3.micro"
  private_ip             = "10.0.2.108"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "worker-2"
  }
}

