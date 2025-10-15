resource "checkpoint_management_host" "example" {
  name         = "tf-host"
  ipv4_address = "192.0.2.20"
  color        = "red"
  tags         = ["tag1", "tag2", "madeByTf"]
  comments     = "This is a new host"
}


resource "checkpoint_management_host" "localhost" {
  name         = "localhost"
  ipv4_address = "127.0.0.1"
  color        = "red"
  tags         = ["madeByTf"]
  comments     = "local host"
  ignore_warnings = true
}

resource "checkpoint_management_host" "example2" {
  name         = "tf-host2"
  ipv4_address = "192.0.2.2"
  color        = "red"
  tags         = ["tag1", "tag2", "madeByTf"]
  comments     = "This is a new host"
}

# resource "checkpoint_management_host" "example2" {
#   name = "tf-host2"
#   ipv4_address = "192.0.2.1"
#   color = "blue"
#   tags = ["tag1", "tag2", "madeByTf"]
#   comments = "This is a new host"
# }