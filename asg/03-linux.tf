module "linux" {
    source = "./03-linux"
    vpc_id = module.network.vpc_id
    keypair_name = module.ssh.keypair_name

    # internal_eni_id = var.internal_eni_id
}