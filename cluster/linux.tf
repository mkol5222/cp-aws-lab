
# linux on private subnet
module "launch_linux" {
  

  source = "../linux"

  subnet_id      = module.launch_vpc.private_subnets_ids_list[0]
  vpc_id         = module.launch_vpc.vpc_id


}
