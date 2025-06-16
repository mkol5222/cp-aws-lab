# module "internal_load_balancer" {
#   count = local.deploy_servers_condition ? 1 : 0

#     source  = "CheckPointSW/cloudguard-network-security/aws//modules/load_balancer"
#     version = "1.0.2"

#   load_balancers_type = var.load_balancers_type
#   instances_subnets = var.servers_subnets
#   prefix_name = "${var.prefix}-Internal"
#   internal = true
#   security_groups = local.alb_condition ? [aws_security_group.internal_security_group[0].id] : []
#   tags = {
#     x-chkp-management = "${var.provision_tag}-management"
#     x-chkp-template = "${var.provision_tag}-template"
#   }
#   vpc_id = var.vpc_id
#   load_balancer_protocol = var.load_balancer_protocol
#   target_group_port = local.encrypted_protocol_condition ? 443 : 80
#   listener_port = local.encrypted_protocol_condition ? "443" : "80"
#   certificate_arn = local.encrypted_protocol_condition ? var.certificate : ""
# }