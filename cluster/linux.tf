
# linux on private subnet

variable "linux_routed" {
  description = "Flag to indicate if Linux instance should be routed through a specific ENI"
  type        = bool
  default     = false
}

resource "aws_subnet" "private_subnet_linux" {
  
  vpc_id = module.launch_vpc.vpc_id //aws_vpc.vpc.id
  availability_zone = "eu-north-1a" // Replace with your desired availability zone
  cidr_block = "172.17.3.0/24"
  # ipv6_cidr_block = var.enable_ipv6 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, var.subnets_bit_length, each.value) : null
  tags = {
    Name = format("Linux Private subnet %s", 3)
  }
}

# routing table for Linux private subnet
resource "aws_route_table" "private_subnet_linux_rtb" {
  
  vpc_id = module.launch_vpc.vpc_id //aws_vpc.vpc.id
  tags = {
    Name = "Linux Private Subnet Route Table"
  }
}

# target tag-name-Member_A_InternalInterface

data "aws_network_interface" "cluster_private_subnet_eni" {
  count = var.linux_routed ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["tag-name-Member_B_ExternalInterface"]
  }
}

# output "eni_id" { 
#   value = try(data.aws_network_interface.cluster_private_subnet_eni.id, null)
# }

resource "aws_route" "linux_private_subnet_route" {
  
  
  count = var.linux_routed ? 1 : 0

  route_table_id = aws_route_table.private_subnet_linux_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  // tag-name-Member_A_InternalInterface eni-0db051ff3bcd86134
  network_interface_id = data.aws_network_interface.cluster_private_subnet_eni[0].id #"eni-0db051ff3bcd86134"
}

resource "aws_route_table_association" "private_subnet_linux_rtb_assoc" {
  
  subnet_id      = aws_subnet.private_subnet_linux.id // module.launch_vpc.private_subnets_ids_list[1]
  route_table_id = aws_route_table.private_subnet_linux_rtb.id
}

module "launch_linux" {
  
  source = "../linux"

  subnet_id      = aws_subnet.private_subnet_linux.id // module.launch_vpc.private_subnets_ids_list[1]
  vpc_id         = module.launch_vpc.vpc_id

    keypair_name      = aws_key_pair.generated_key.key_name
}

output "debug_priv_subnets" {
  value = module.launch_vpc.private_subnets_ids_list
}