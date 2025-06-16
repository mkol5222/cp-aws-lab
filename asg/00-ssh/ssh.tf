resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "cluster-module-keypair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

output "private_key_pem" {
  description = "Private key content (PEM format)"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

# Optional: Write private key to a local file (do NOT commit this file!)
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/../../secrets/asg-keypair.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}