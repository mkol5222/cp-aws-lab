resource "checkpoint_management_data_center_query" "cpman_SecurityGroup" {
  name         = "cpman_SecurityGroup"
  data_centers = [checkpoint_management_aws_data_center_server.aws_dc.name]
  query_rules {
    key_type = "predefined"
    key      = "type-in-data-center"
    values   = ["Security Group"]
  }
    query_rules {
    key_type = "tag"
    key      = "Name"
    values   = ["cpman_SecurityGroup"]
  }
#   query_rules {
#     key_type = "predefined"
#     key      = "name-in-data-center"
#     values   = ["cpman_SecurityGroup"]
#   }
}

resource "checkpoint_management_data_center_query" "allSGs" {

  depends_on   = [checkpoint_management_aws_data_center_server.aws_dc]
  name         = "SGs in AWS"
  data_centers = ["All"]
  query_rules {
    key_type = "predefined"
    key      = "type-in-data-center"
    values   = ["Security Group"]
  }
}