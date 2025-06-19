resource "checkpoint_management_access_section" "misc" {
  name = "misc"
  position = {top = "top"}
  layer = "${checkpoint_management_package.cluster.name} Network"
}

resource "checkpoint_management_access_section" "egress" {
  name = "Egress traffic"
  position = {above = checkpoint_management_access_section.misc.id }
  layer = "${checkpoint_management_package.cluster.name} Network"
}

resource "checkpoint_management_access_rule" "from_net_linux" {
  layer = "${checkpoint_management_package.cluster.name} Network"
  
  position = { below = checkpoint_management_access_section.egress.id }
  name     = "from Linux subnet"

  source = [checkpoint_management_network.linux.id]

  enabled = true

  destination        = ["Any"]
  destination_negate = false

  service        = ["Any"]
  service_negate = false

  action = "Accept"
  action_settings = {
    enable_identity_captive_portal = false
  }

  track = {
    accounting              = false
    alert                   = "none"
    enable_firewall_session = true
    per_connection          = true
    per_session             = true
    type                    = "Log"
  }
}

resource "checkpoint_management_access_section" "ingress" {
  name = "Ingress traffic"
  position = {above = checkpoint_management_access_section.misc.id }
  layer = "${checkpoint_management_package.cluster.name} Network"
}