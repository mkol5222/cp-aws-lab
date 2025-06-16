module "asg" {
  source  = "./02-asg"

  vpc_id = module.network.vpc_id
  public_subnets = module.network.public_subnets

  keypair_name = module.ssh.keypair_name
}