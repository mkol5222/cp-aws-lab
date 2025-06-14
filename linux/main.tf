
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
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id # "ami-0c55b159cbfafe1f0" # Example AMI for Ubuntu 24.04 LTS
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "UbuntuInstance"
    Environment = "Development"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /home/ubuntu/hello.txt
              EOF
}