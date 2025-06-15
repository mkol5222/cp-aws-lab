# permissive SG allowing all traffic
resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow all traffic"
vpc_id      = var.vpc_id // var.subnet_id == null ? module.launch_vpc[0].vpc_id : var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "sg"
    }
}