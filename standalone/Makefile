up:
	terraform init
	terraform apply -target=module.standalone_cp.aws_route_table.private_subnet_rtb -auto-approve && terraform apply -auto-approve
	terraform apply -auto-approve -target module.cme_role