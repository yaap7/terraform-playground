output "aws_hcat_ip" {
  value = aws_instance.hcat.public_ip
}

output "to_ssh" {
  value = "ssh -i ${local_file.ssh_private_key_pem.filename} ubuntu@${aws_instance.hcat.public_ip}"
}
