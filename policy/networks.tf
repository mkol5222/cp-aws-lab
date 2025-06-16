resource "checkpoint_management_network" "linux" {
  name = "net-linux"
  subnet4 = "172.17.3.0"
  mask_length4 =24
  color = "blue"
}