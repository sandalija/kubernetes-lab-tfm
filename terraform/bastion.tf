data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["amazon"] # Amazon official AMIs

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] # For x86_64 architecture
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


data "http" "current_ip" {
  url = "https://checkip.amazonaws.com/"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.aws_availability_zone
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH from deployment station"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.current_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "BastionHost"
  }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30 && \
      scp -o StrictHostKeyChecking=no -i ~/.ssh/bastion-key.pem ${var.public_key_path} ec2-user@${self.public_ip}:/home/ec2-user/${var.public_key_path} && \
      ssh -o StrictHostKeyChecking=no -i ~/.ssh/bastion-key.pem ec2-user@${self.public_ip} "chmod 600 /home/ec2-user/${var.public_key_path}"
    EOT
  }
}

