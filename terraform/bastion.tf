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



resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "bastion"
  }

  user_data = <<EOF
#!/bin/bash

mkdir -p /home/ec2-user/.ssh

echo "Host 10.0.*
  User ec2-user
  IdentityFile /home/ec2-user/cluster.pem
  StrictHostKeyChecking no" > /home/ec2-user/.ssh/config

chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/config

# Install kubectl
curl -Lo /usr/local/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.1/2024-03-20/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl

# Install k9s
curl -Lo /usr/local/bin/k9s https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar -xzvf /usr/local/bin/k9s -C /usr/local/bin/ k9s
chmod +x /usr/local/bin/k9s

# Make sure ec2-user has access to binaries
chown ec2-user:ec2-user /usr/local/bin/kubectl
chown ec2-user:ec2-user /usr/local/bin/k9s
EOF

  provisioner "local-exec" {
    command = <<EOT
      sleep 30 && \
      scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.private_key_path} ec2-user@${self.public_ip}:/home/ec2-user/cluster.pem
    EOT
  }
}
