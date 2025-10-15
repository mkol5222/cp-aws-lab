resource "checkpoint_management_host" "codespace" {
  name = "codespace"
  ipv4_address = local.codespace_ip
  color = "blue"
  tags = ["tag1", "tag2", "madeByTf"]
  comments = "Codespace host used for management"
  ignore_warnings = true
}

data "http" "myip" {
  url = "http://ip.iol.cz/ip/"
}

locals {
    codespace_ip = data.http.myip.response_body
}
output "codespace_ip" {
  value = local.codespace_ip
}