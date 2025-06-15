module "cluster" {
    source = "./02-cluster"

    vpc_id = module.network.vpc_id
    public_subnets = module.network.public_subnets
    private_subnets = module.network.private_subnets

    keypair_name = module.ssh.keypair_name
}