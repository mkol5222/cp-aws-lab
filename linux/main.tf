# Ubuntu 24.04 LTS small VM on selected VPC subnet-id

# AMI for Ubuntu 24.04 LTS in the specified region
provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"] # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-24.04-amd64-server-*", "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

// SG allowing SSH access
resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH access"
  vpc_id      = module.launch_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0/0"] # Allow SSH from anywhere (not recommended for production)
    # You can restrict this to your IP or a specific range for better security
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0/0"]
  }
  tags = {
    Name        = "SSHAccess"
    Environment = "Development"
  }
}



resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.launch_vpc.public_subnets_ids_list[0]
  key_name      = aws_key_pair.generated_key.key_name // var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]

  tags = {
    Name        = "linux"
    Environment = "Development"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /home/ubuntu/hello.txt
              EOF
}