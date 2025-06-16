resource "checkpoint_management_aws_data_center_server" "aws_dc" {
  name                  = "aws-dc"
  authentication_method = "role-authentication"
  #   access_key_id          = "MY-KEY-ID"
  #   secret_access_key      = "MY-SECRET-KEY"
  region = "eu-north-1"
}