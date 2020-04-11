resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  sensitive_content = tls_private_key.ssh.private_key_pem
  filename          = "./ssh_keys/${var.instance_name}"
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_pem" {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "./ssh_keys/${var.instance_name}.pub"
  file_permission = "0600"
}
