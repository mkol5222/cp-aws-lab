module "cluster" {
    source = "./02-cluster"

    vpc_id = module.network.vpc_id
    public_subnets = module.network.public_subnets
    private_subnets = module.network.private_subnets

    keypair_name = aws_key_pair.generated_key.key_name
}