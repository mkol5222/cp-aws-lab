module "cme_role" {

    source  = "CheckPointSW/cloudguard-network-security/aws//modules/cme_iam_role"
    version = "1.0.2"

    permissions = "Create with read permissions"
}


